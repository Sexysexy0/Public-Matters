// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title AutoPenaltyEscrowV5
 * @notice Escrows corporate penalties, splits funds to community + households
 *         using a severity-weighted multiplier, and exposes on-chain dashboard
 *         views with full source mapping, emotional APR, and damay clause logs.
 */
contract AutoPenaltyEscrowV5 {
    address public steward;
    address public utilityTreasury;

    // Basis points: 10000 = 100%
    uint16 public constant BPS = 10_000;

    enum Severity { Low, Medium, High, Critical }

    struct Company {
        string name;
        address operator;
        bool registered;
        uint256 escrowBalance;
    }

    struct Household {
        bool verified;
        address wallet;
    }

    struct PayoutRecord {
        uint256 totalAmount;
        uint256 toCommunity;
        uint256 toHouseholdsTotal;
        uint256 perHousehold;
        string purpose;
        string emotionalAPR;
        string damayClause;
        address sourceCompany;
        string violationType;
        Severity severity;
        uint16 householdBps; // share used during this payout
    }

    // Admin + registries
    mapping(address => bool) public regulators;
    mapping(address => Company) public companies;
    mapping(address => Household) public households;
    address[] public householdIndex;

    // Severity schedule (household share in BPS; community share = 10000 - householdBps)
    mapping(uint8 => uint16) public severityHouseholdBps; // key = uint8(Severity)

    // Payout + stats
    mapping(uint256 => PayoutRecord) public payoutLedger;
    uint256 public payoutCount;
    uint256 public householdCount;

    // Aggregates for dashboard
    uint256 public totalPenaltiesReceived;
    uint256 public totalSentToCommunity;
    uint256 public totalSentToHouseholds;
    mapping(address => uint256) public companyPenaltiesTotal; // by company id

    // Events
    event CompanyRegistered(address indexed id, address indexed operator, string name);
    event HouseholdRegistered(address indexed wallet);
    event HouseholdUnregistered(address indexed wallet);
    event PenaltyDeposited(address indexed operator, uint256 amount, string violationType, Severity severity);
    event CommunityPaid(uint256 amount, string purpose, string emotionalAPR, string damayClause);
    event HouseholdReward(address indexed wallet, uint256 amount, string purpose, address sourceCompany, string violationType, Severity severity);
    event SeverityScheduleUpdated(Severity severity, uint16 householdBps);
    event UtilityTreasuryUpdated(address newTreasury);

    modifier onlySteward() {
        require(msg.sender == steward, "Not steward");
        _;
    }

    modifier onlyRegulator() {
        require(regulators[msg.sender], "Not regulator");
        _;
    }

    constructor(address _utilityTreasury) {
        steward = msg.sender;
        utilityTreasury = _utilityTreasury;
        regulators[msg.sender] = true;

        // Default schedule: higher severity => more to households
        severityHouseholdBps[uint8(Severity.Low)]      = 5000; // 50% households / 50% community
        severityHouseholdBps[uint8(Severity.Medium)]   = 6000; // 60% / 40%
        severityHouseholdBps[uint8(Severity.High)]     = 7000; // 70% / 30%
        severityHouseholdBps[uint8(Severity.Critical)] = 8000; // 80% / 20%
    }

    // --- Admin ---

    function setRegulator(address reg, bool status) external onlySteward {
        regulators[reg] = status;
    }

    function setUtilityTreasury(address newTreasury) external onlySteward {
        require(newTreasury != address(0), "Zero treasury");
        utilityTreasury = newTreasury;
        emit UtilityTreasuryUpdated(newTreasury);
    }

    function setSeverityHouseholdBps(Severity s, uint16 householdBps_) external onlySteward {
        require(householdBps_ <= BPS, "Bps > 100%");
        severityHouseholdBps[uint8(s)] = householdBps_;
        emit SeverityScheduleUpdated(s, householdBps_);
    }

    function registerCompany(address id, address op, string calldata name) external onlySteward {
        companies[id] = Company(name, op, true, 0);
        emit CompanyRegistered(id, op, name);
    }

    function registerHousehold(address wallet) external onlySteward {
        require(wallet != address(0), "Zero wallet");
        require(!households[wallet].verified, "Already verified");
        households[wallet] = Household(true, wallet);
        householdIndex.push(wallet);
        householdCount++;
        emit HouseholdRegistered(wallet);
    }

    function unregisterHousehold(address wallet) external onlySteward {
        require(households[wallet].verified, "Not verified");
        households[wallet].verified = false;
        householdCount--;
        emit HouseholdUnregistered(wallet);
        // Optional: keep index entry for historical audit; skip array compaction for gas
    }

    // --- Core flow ---

    function logPenalty(
        address id,
        string calldata violationType,
        Severity severity,
        string calldata emotionalAPR,
        string calldata damayClause
    ) external payable onlyRegulator {
        Company storage c = companies[id];
        require(c.registered, "Not registered");
        require(msg.value > 0, "No penalty amount");

        // Bookkeeping
        c.escrowBalance += msg.value;
        totalPenaltiesReceived += msg.value;
        companyPenaltiesTotal[id] += msg.value;

        emit PenaltyDeposited(c.operator, msg.value, violationType, severity);

        _autoDistribute(id, violationType, severity, emotionalAPR, damayClause);
    }

    function _autoDistribute(
        address id,
        string memory violationType,
        Severity severity,
        string memory emotionalAPR,
        string memory damayClause
    ) internal {
        Company storage c = companies[id];
        uint256 payout = c.escrowBalance;
        c.escrowBalance = 0;

        uint16 hhBps = severityHouseholdBps[uint8(severity)];
        uint256 toHouseholds = (payout * hhBps) / BPS;
        uint256 toCommunity = payout - toHouseholds;

        // Send to community treasury first
        if (toCommunity > 0) {
            (bool okC, ) = payable(utilityTreasury).call{value: toCommunity}("");
            require(okC, "Community transfer failed");
            totalSentToCommunity += toCommunity;
        }

        // Distribute to households
        uint256 perHH = 0;
        if (householdCount > 0 && toHouseholds > 0) {
            perHH = toHouseholds / householdCount;
            uint256 distributed = 0;

            if (perHH > 0) {
                for (uint256 i = 0; i < householdIndex.length; i++) {
                    address w = householdIndex[i];
                    if (households[w].verified) {
                        (bool okH, ) = payable(w).call{value: perHH}("");
                        // If one transfer fails, continue others; untransferred amounts become residue
                        if (okH) {
                            distributed += perHH;
                            emit HouseholdReward(w, perHH, "Penalty micro-disbursement",
                                id, violationType, severity);
                        }
                    }
                }
            }

            // Residue (from rounding or failed sends) goes to community fund
            uint256 residue = toHouseholds - distributed;
            if (residue > 0) {
                (bool okR, ) = payable(utilityTreasury).call{value: residue}("");
                require(okR, "Residue transfer failed");
                toCommunity += residue;
                toHouseholds = distributed;
                totalSentToCommunity += residue;
            }

            totalSentToHouseholds += toHouseholds;
        } else {
            // No households verified; all to community
            (bool okAll, ) = payable(utilityTreasury).call{value: toHouseholds}("");
            require(okAll, "Fallback community transfer failed");
            toCommunity += toHouseholds;
            toHouseholds = 0;
            totalSentToCommunity += toHouseholds; // zero-add safe; keeps symmetry
        }

        // Record payout
        payoutCount++;
        payoutLedger[payoutCount] = PayoutRecord({
            totalAmount: payout,
            toCommunity: toCommunity,
            toHouseholdsTotal: toHouseholds,
            perHousehold: perHH,
            purpose: "Electric utility + household rewards (severity-weighted)",
            emotionalAPR: emotionalAPR,
            damayClause: damayClause,
            sourceCompany: id,
            violationType: violationType,
            severity: severity,
            householdBps: hhBps
        });

        emit CommunityPaid(
            payout,
            "Electric utility + household rewards (severity-weighted)",
            emotionalAPR,
            damayClause
        );
    }

    // --- Public dashboard views (read-only) ---

    function getHouseholds() external view returns (address[] memory) {
        return householdIndex;
    }

    function getTotals()
        external
        view
        returns (
            uint256 penaltiesReceived,
            uint256 sentToCommunity,
            uint256 sentToHouseholds,
            uint256 payouts,
            uint256 householdsVerified
        )
    {
        return (
            totalPenaltiesReceived,
            totalSentToCommunity,
            totalSentToHouseholds,
            payoutCount,
            householdCount
        );
    }

    function getCompanyStats(address id)
        external
        view
        returns (
            string memory name,
            address operator,
            bool registered,
            uint256 escrowBalance,
            uint256 penaltiesTotal
        )
    {
        Company memory c = companies[id];
        return (c.name, c.operator, c.registered, c.escrowBalance, companyPenaltiesTotal[id]);
    }

    function getPayout(uint256 id_)
        external
        view
        returns (
            uint256 totalAmount,
            uint256 toCommunity,
            uint256 toHouseholdsTotal,
            uint256 perHousehold,
            string memory purpose,
            string memory emotionalAPR,
            string memory damayClause,
            address sourceCompany,
            string memory violationType,
            Severity severity,
            uint16 householdBps
        )
    {
        PayoutRecord memory p = payoutLedger[id_];
        return (
            p.totalAmount,
            p.toCommunity,
            p.toHouseholdsTotal,
            p.perHousehold,
            p.purpose,
            p.emotionalAPR,
            p.damayClause,
            p.sourceCompany,
            p.violationType,
            p.severity,
            p.householdBps
        );
    }
}
