// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title HousingGuaranteeActV1
 * @notice Government-backed housing guarantee with priority scoring,
 *         rent-to-own escrow, subsidy disbursement, occupancy proofs,
 *         and revocation/reassignment for misuse.
 */
contract HousingGuaranteeActV1 {
    address public steward; // gov program admin

    uint16 public constant BPS = 10_000;

    enum UnitStatus { Available, Reserved, Occupied }
    enum IncomeBracket { Low, LowerMiddle, Middle }
    enum Investigation { None, Open, Closed }

    struct Family {
        string  headName;
        address wallet;
        string  barangay;
        bool    registered;
        bool    cohabiting;        // nakikitira sa magulang/kapamilya
        uint8   householdSize;
        uint8   minors;
        uint8   elderly;
        IncomeBracket income;
        bool    eligible;
        uint256 priorityScore;
        uint256 allocatedUnitId;   // 0 if none
        uint8   strikes;           // misuse strikes
        Investigation invStatus;
        bool    active;            // has live allocation/license
    }

    struct Unit {
        uint256 id;
        string  location;          // textual (Blk/Lot/Bldg)
        string  barangay;
        address developer;         // whitelisted developer/owner
        uint256 price;             // reference/valuation
        uint256 monthlyRent;       // rent-to-own monthly
        UnitStatus status;
        address assignedTo;
        uint256 resaleLockUntil;   // timestamp
    }

    // Admin sets these to tune scoring
    struct ScoreWeights {
        uint16 cohabitingBoost;    // e.g., 2000 = +20%
        uint16 perMinor;           // per child points in bps of base
        uint16 perElderly;         // per senior points
        uint16 incomeLowBoost;     // boost for low income
        uint16 barangayWeight;     // default barangay multiplier
    }

    mapping(address => bool) public auditors;
    mapping(address => bool) public developers;

    // Barangay targeting (e.g., boost Bangkal / Northville 8)
    mapping(string => uint16) public barangayBoostBps; // additional multiplier per barangay

    mapping(address => Family) public families;
    mapping(uint256 => Unit)   public units;
    uint256 public unitCount;

    // Subsidy/share config
    uint16  public subsidyBps = 6000;      // gov pays 60%, family pays 40% by default
    uint256 public resaleLockDays = 3650;  // ~10 years resale/transfer lock

    ScoreWeights public W = ScoreWeights({
        cohabitingBoost: 2000,
        perMinor: 300,        // +3% per child
        perElderly: 200,      // +2% per senior
        incomeLowBoost: 1500, // +15% for low income
        barangayWeight: 10000 // baseline 100%
    });

    // Occupancy proofs: unitId => month => evidence hash
    mapping(uint256 => mapping(uint256 => string)) public occupancyProof; 
    // Investigation notes
    event InvestigationOpened(address family, string reason);
    event InvestigationClosed(address family, string outcome);

    // Events
    event AuditorSet(address auditor, bool status);
    event DeveloperSet(address dev, bool status);
    event BarangayBoostSet(string barangay, uint16 bps);
    event FamilyRegistered(address wallet, string name, string barangay);
    event EligibilityVerified(address wallet, bool eligible, uint256 priorityScore);
    event UnitAdded(uint256 unitId, string location, string barangay, uint256 monthlyRent, address developer);
    event UnitAllocated(uint256 unitId, address family);
    event OccupancySigned(uint256 unitId, address family, uint256 resaleLockUntil);
    event SubsidyPaid(uint256 unitId, uint256 amount);
    event FamilyPaidRent(uint256 unitId, address family, uint256 amount);
    event ProofSubmitted(uint256 unitId, uint256 month, string hashRef);
    event MisuseStrike(address family, uint8 strikes, string reasonCode);
    event AllocationRevoked(uint256 unitId, address family, string reason);
    event UnitReassigned(uint256 unitId, address newFamily);

    modifier onlySteward() { require(msg.sender == steward, "Not steward"); _; }
    modifier onlyAuditor() { require(auditors[msg.sender], "Not auditor"); _; }

    constructor() { steward = msg.sender; auditors[msg.sender] = true; }

    // --- Admin controls ---

    function setAuditor(address a, bool s) external onlySteward { auditors[a] = s; emit AuditorSet(a, s); }
    function setDeveloper(address d, bool s) external onlySteward { developers[d] = s; emit DeveloperSet(d, s); }
    function setWeights(ScoreWeights calldata w) external onlySteward { W = w; }
    function setSubsidyBps(uint16 bps) external onlySteward { require(bps <= BPS, "bps>100%"); subsidyBps = bps; }
    function setResaleLockDays(uint256 days_) external onlySteward { resaleLockDays = days_; }
    function setBarangayBoost(string calldata b, uint16 bps) external onlySteward { barangayBoostBps[b] = bps; emit BarangayBoostSet(b, bps); }

    // --- Family lifecycle ---

    function registerFamily(
        address wallet,
        string calldata headName,
        string calldata barangay,
        bool cohabiting,
        uint8 householdSize,
        uint8 minors,
        uint8 elderly,
        IncomeBracket income
    ) external onlySteward {
        families[wallet] = Family({
            headName: headName,
            wallet: wallet,
            barangay: barangay,
            registered: true,
            cohabiting: cohabiting,
            householdSize: householdSize,
            minors: minors,
            elderly: elderly,
            income: income,
            eligible: false,
            priorityScore: 0,
            allocatedUnitId: 0,
            strikes: 0,
            invStatus: Investigation.None,
            active: false
        });
        emit FamilyRegistered(wallet, headName, barangay);
    }

    function verifyEligibility(address wallet, bool eligible) external onlyAuditor {
        Family storage f = families[wallet];
        require(f.registered, "Not registered");
        f.eligible = eligible;
        f.priorityScore = eligible ? _computePriority(f) : 0;
        emit EligibilityVerified(wallet, eligible, f.priorityScore);
    }

    function _computePriority(Family memory f) internal view returns (uint256) {
        // Base = 10000
        uint256 score = 10_000;
        if (f.cohabiting) score += W.cohabitingBoost;
        score += uint256(f.minors) * W.perMinor;
        score += uint256(f.elderly) * W.perElderly;
        if (f.income == IncomeBracket.Low) score += W.incomeLowBoost;
        // Barangay boost
        uint16 bBoost = barangayBoostBps[f.barangay];
        if (bBoost > 0) score = (score * (W.barangayWeight + bBoost)) / BPS;
        else score = (score * W.barangayWeight) / BPS;
        return score;
    }

    // --- Units & allocation ---

    function addUnit(
        string calldata location,
        string calldata barangay,
        address developerAddr,
        uint256 price,
        uint256 monthlyRent
    ) external onlySteward {
        require(developers[developerAddr], "Dev not whitelisted");
        unitCount++;
        units[unitCount] = Unit({
            id: unitCount,
            location: location,
            barangay: barangay,
            developer: developerAddr,
            price: price,
            monthlyRent: monthlyRent,
            status: UnitStatus.Available,
            assignedTo: address(0),
            resaleLockUntil: 0
        });
        emit UnitAdded(unitCount, location, barangay, monthlyRent, developerAddr);
    }

    function allocateUnit(address familyWallet, uint256 unitId) external onlySteward {
        Family storage f = families[familyWallet];
        Unit storage u = units[unitId];
        require(f.eligible && f.registered, "Family not eligible");
        require(u.status == UnitStatus.Available, "Unit not available");
        require(f.allocatedUnitId == 0, "Family already allocated");

        u.status = UnitStatus.Reserved;
        u.assignedTo = familyWallet;
        f.allocatedUnitId = unitId;

        emit UnitAllocated(unitId, familyWallet);
    }

    function signOccupancy(uint256 unitId) external {
        Unit storage u = units[unitId];
        require(u.assignedTo == msg.sender, "Not assignee");
        require(u.status == UnitStatus.Reserved, "Not reserved");
        u.status = UnitStatus.Occupied;
        u.resaleLockUntil = block.timestamp + (resaleLockDays * 1 days);

        Family storage f = families[msg.sender];
        f.active = true;

        emit OccupancySigned(unitId, msg.sender, u.resaleLockUntil);
    }

    // --- Payments & subsidy ---

    function payFamilyShare(uint256 unitId) external payable {
        Unit storage u = units[unitId];
        require(u.status == UnitStatus.Occupied && u.assignedTo == msg.sender, "Not occupant");
        uint256 familyDue = (u.monthlyRent * (BPS - subsidyBps)) / BPS;
        require(msg.value == familyDue, "Incorrect amount");
        (bool ok, ) = payable(u.developer).call{value: msg.value}("");
        require(ok, "Family->Dev transfer failed");
        emit FamilyPaidRent(unitId, msg.sender, msg.value);
    }

    function paySubsidy(uint256 unitId) external onlySteward {
        Unit storage u = units[unitId];
        require(u.status == UnitStatus.Occupied, "Unit not occupied");
        uint256 subsidy = (u.monthlyRent * subsidyBps) / BPS;
        (bool ok, ) = payable(u.developer).call{value: subsidy}("");
        require(ok, "Subsidy transfer failed");
        emit SubsidyPaid(unitId, subsidy);
    }

    // --- Occupancy proof ---

    function submitOccupancyProof(uint256 unitId, uint256 month, string calldata evidenceHash) external {
        Unit storage u = units[unitId];
        require(u.assignedTo == msg.sender, "Not occupant");
        occupancyProof[unitId][month] = evidenceHash;
        emit ProofSubmitted(unitId, month, evidenceHash);
    }

    // --- Investigations, strikes, revocation ---

    function openInvestigation(address familyWallet, string calldata reasonCode) external onlyAuditor {
        Family storage f = families[familyWallet];
        require(f.registered, "Not registered");
        f.invStatus = Investigation.Open;
        emit InvestigationOpened(familyWallet, reasonCode);
    }

    function flagMisuse(address familyWallet, string calldata reasonCode) external onlyAuditor {
        Family storage f = families[familyWallet];
        require(f.registered, "Not registered");
        f.strikes += 1;
        emit MisuseStrike(familyWallet, f.strikes, reasonCode);
        if (f.strikes >= 3) {
            _revokeAllocation(familyWallet, "3 strikes misuse");
        }
    }

    function closeInvestigation(address familyWallet, string calldata outcome) external onlyAuditor {
        Family storage f = families[familyWallet];
        require(f.invStatus == Investigation.Open, "No open investigation");
        f.invStatus = Investigation.Closed;
        emit InvestigationClosed(familyWallet, outcome);
    }

    function _revokeAllocation(address familyWallet, string memory reason) internal {
        Family storage f = families[familyWallet];
        uint256 unitId = f.allocatedUnitId;
        if (unitId != 0) {
            Unit storage u = units[unitId];
            u.status = UnitStatus.Available;
            u.assignedTo = address(0);
            u.resaleLockUntil = 0;
            emit AllocationRevoked(unitId, familyWallet, reason);
        }
        f.active = false;
        f.allocatedUnitId = 0;
    }

    function reassignUnit(uint256 unitId, address newFamilyWallet) external onlySteward {
        Unit storage u = units[unitId];
        require(u.status == UnitStatus.Available, "Not free");
        Family storage nf = families[newFamilyWallet];
        require(nf.eligible && nf.allocatedUnitId == 0, "New family not eligible/free");
        allocateUnit(newFamilyWallet, unitId);
    }

    // --- Funding ---

    receive() external payable {}
}
