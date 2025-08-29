// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title HousingGuaranteeActV2
 * @notice LandBank-style escrow: holds family + subsidy shares per month,
 *         releases to developer when complete, and auto-issues title after N on-time payments.
 */
contract HousingGuaranteeActV2 {
    address public steward;           // program admin (gov)
    uint16  public constant BPS = 10_000;

    enum UnitStatus { Available, Reserved, Occupied }
    enum IncomeBracket { Low, LowerMiddle, Middle }

    struct Family {
        string headName;
        address wallet;
        bool registered;
        bool eligible;
    }

    struct Unit {
        uint256 id;
        string  location;
        address developer;
        uint256 monthlyRent;
        uint256 termMonths;           // required months for title
        UnitStatus status;
        address assignedTo;
        uint256 occupancyStart;       // timestamp when occupancy signed
        uint256 graceDays;            // per-month grace period for "on-time"
    }

    struct MonthLedger {
        bool familyPaid;
        bool subsidyPaid;
        uint256 familyPaidAt;         // timestamp for on-time check
        uint256 familyAmt;
        uint256 subsidyAmt;
        bool released;
    }

    struct Progress {
        uint256 onTimePaidMonths;
        uint256 lastSettledMonth;     // highest monthIndex settled
    }

    struct Title {
        bool issued;
        address owner;
        uint256 issuedAt;
    }

    mapping(address => bool) public developers;
    mapping(address => bool) public auditors;

    mapping(address => Family) public families;
    mapping(uint256 => Unit)   public units;
    mapping(uint256 => mapping(uint256 => MonthLedger)) public ledgers; // unitId => monthIndex => ledger
    mapping(uint256 => Progress) public progress; // unitId => progress
    mapping(uint256 => Title)    public titles;   // unitId => title

    uint256 public unitCount;
    uint16  public subsidyBps = 6000; // gov 60%, family 40%

    event DeveloperSet(address dev, bool status);
    event AuditorSet(address auditor, bool status);
    event FamilyRegistered(address wallet, string headName);
    event UnitAdded(uint256 unitId, string location, address developer, uint256 monthlyRent, uint256 termMonths, uint256 graceDays);
    event UnitAllocated(uint256 unitId, address family);
    event OccupancySigned(uint256 unitId, address family, uint256 start);
    event FamilyPaid(uint256 unitId, uint256 monthIndex, uint256 amount);
    event SubsidyDeposited(uint256 unitId, uint256 monthIndex, uint256 amount);
    event MonthSettled(uint256 unitId, uint256 monthIndex, uint256 totalReleased);
    event TitleIssued(uint256 unitId, address owner, uint256 at);

    modifier onlySteward() { require(msg.sender == steward, "Not steward"); _; }
    modifier onlyAuditor() { require(auditors[msg.sender], "Not auditor"); _; }

    constructor() { steward = msg.sender; auditors[msg.sender] = true; }

    // Admin
    function setDeveloper(address dev, bool s) external onlySteward { developers[dev] = s; emit DeveloperSet(dev,s); }
    function setAuditor(address a, bool s) external onlySteward { auditors[a]=s; emit AuditorSet(a,s); }
    function setSubsidyBps(uint16 bps) external onlySteward { require(bps<=BPS,"bps>100%"); subsidyBps=bps; }

    // Families & Units
    function registerFamily(address wallet, string calldata name, bool eligible) external onlySteward {
        families[wallet] = Family(name, wallet, true, eligible);
        emit FamilyRegistered(wallet, name);
    }

    function addUnit(
        string calldata location,
        address developer,
        uint256 monthlyRent,
        uint256 termMonths,
        uint256 graceDays
    ) external onlySteward {
        require(developers[developer], "Dev not whitelisted");
        unitCount++;
        units[unitCount] = Unit({
            id: unitCount,
            location: location,
            developer: developer,
            monthlyRent: monthlyRent,
            termMonths: termMonths,
            status: UnitStatus.Available,
            assignedTo: address(0),
            occupancyStart: 0,
            graceDays: graceDays
        });
        emit UnitAdded(unitCount, location, developer, monthlyRent, termMonths, graceDays);
    }

    function allocateUnit(address familyWallet, uint256 unitId) external onlySteward {
        Family storage f = families[familyWallet];
        Unit storage u = units[unitId];
        require(f.registered && f.eligible, "Family not eligible");
        require(u.status == UnitStatus.Available, "Unit not available");
        u.status = UnitStatus.Reserved;
        u.assignedTo = familyWallet;
        emit UnitAllocated(unitId, familyWallet);
    }

    function signOccupancy(uint256 unitId) external {
        Unit storage u = units[unitId];
        require(u.assignedTo == msg.sender, "Not assignee");
        require(u.status == UnitStatus.Reserved, "Not reserved");
        u.status = UnitStatus.Occupied;
        u.occupancyStart = block.timestamp;
        emit OccupancySigned(unitId, msg.sender, u.occupancyStart);
    }

    // Payments → held in escrow (this contract)
    function _familyDue(Unit memory u) internal view returns (uint256) {
        return (u.monthlyRent * (BPS - subsidyBps)) / BPS;
    }
    function _subsidyDue(Unit memory u) internal view returns (uint256) {
        return (u.monthlyRent * subsidyBps) / BPS;
    }

    // monthIndex starts at 1 for the first month after occupancyStart
    function payFamilyShare(uint256 unitId, uint256 monthIndex) external payable {
        Unit storage u = units[unitId];
        require(u.status == UnitStatus.Occupied, "Not occupied");
        require(u.assignedTo == msg.sender, "Not occupant");
        require(monthIndex >= 1 && monthIndex <= u.termMonths, "Invalid month");

        uint256 due = _familyDue(u);
        require(msg.value == due, "Incorrect amount");

        MonthLedger storage m = ledgers[unitId][monthIndex];
        require(!m.familyPaid, "Already paid by family");
        m.familyPaid = true;
        m.familyPaidAt = block.timestamp;
        m.familyAmt = msg.value;

        emit FamilyPaid(unitId, monthIndex, msg.value);
    }

    function depositSubsidy(uint256 unitId, uint256 monthIndex) external payable onlySteward {
        Unit storage u = units[unitId];
        require(u.status == UnitStatus.Occupied, "Not occupied");
        require(monthIndex >= 1 && monthIndex <= u.termMonths, "Invalid month");

        uint256 due = _subsidyDue(u);
        require(msg.value == due, "Incorrect subsidy");

        MonthLedger storage m = ledgers[unitId][monthIndex];
        require(!m.subsidyPaid, "Subsidy already paid");
        m.subsidyPaid = true;
        m.subsidyAmt = msg.value;

        emit SubsidyDeposited(unitId, monthIndex, msg.value);
    }

    function _dueDate(Unit memory u, uint256 monthIndex) internal pure returns (uint256) {
        // For simplicity: assume 30-day months; callers can adapt as needed.
        return u.occupancyStart + (monthIndex * 30 days);
    }

    function settleMonth(uint256 unitId, uint256 monthIndex) external {
        Unit storage u = units[unitId];
        MonthLedger storage m = ledgers[unitId][monthIndex];
        Progress storage p = progress[unitId];

        require(u.status == UnitStatus.Occupied, "Not occupied");
        require(m.familyPaid && m.subsidyPaid, "Incomplete funds");
        require(!m.released, "Already released");

        m.released = true;
        p.lastSettledMonth = monthIndex;

        // On-time check
        uint256 cutoff = _dueDate(u, monthIndex) + (u.graceDays * 1 days);
        if (m.familyPaidAt <= cutoff) {
            p.onTimePaidMonths += 1;
        }

        uint256 total = m.familyAmt + m.subsidyAmt;
        (bool ok, ) = payable(u.developer).call{value: total}("");
        require(ok, "Release to dev failed");

        emit MonthSettled(unitId, monthIndex, total);

        // Title issuance trigger
        if (!titles[unitId].issued && p.onTimePaidMonths >= u.termMonths) {
            titles[unitId] = Title(true, u.assignedTo, block.timestamp);
            emit TitleIssued(unitId, u.assignedTo, block.timestamp);
        }
    }

    receive() external payable {}
}
