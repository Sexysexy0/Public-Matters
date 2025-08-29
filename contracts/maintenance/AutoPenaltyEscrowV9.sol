// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title AutoPenaltyEscrowV9
 * @notice Cross-barangay pooling + Disaster Mode + AI-assisted Needs Forecasting.
 * @dev Off-chain forecasting engine computes ReliefPlan and posts hash on-chain for audit.
 */
contract AutoPenaltyEscrowV9 {
    address public steward;

    uint16 public constant BPS = 10_000;
    enum Severity { Low, Medium, High, Critical }
    enum ReliefType { Cash, Food, Water, Medical, Power }

    struct Community {
        string name;
        address treasury;
        uint256 impactWeight;
        bool active;
    }

    struct Company {
        string name;
        address operator;
        bool registered;
    }

    struct Offense {
        string code;
        string description;
        Severity severity;
        bool exists;
    }

    struct ReliefPlan {
        ReliefType reliefType;
        uint256 cashAmount;
        string notes; // summary from AI forecast
    }

    struct PoolDistribution {
        uint256 totalAmount;
        string emotionalAPR;
        string damayClause;
        address sourceCompany;
        string offenseCode;
        Severity severity;
        bool disasterMode;
        uint16 disasterMultiplierBps;
        mapping(address => ReliefPlan) reliefPerCommunity;
    }

    mapping(address => bool) public regulators;
    mapping(address => Company) public companies;
    mapping(string => Offense) public offenseCatalog;
    mapping(address => Community) public communities;
    address[] public communityList;

    mapping(uint8 => uint16) public severityHouseholdBps;

    mapping(uint256 => PoolDistribution) public pools;
    uint256 public poolCount;

    event CompanyRegistered(address indexed id, address operator, string name);
    event CommunityRegistered(address indexed treasury, string name, uint256 impactWeight);
    event OffenseRegistered(string code, string description, Severity severity);
    event PenaltyPooled(uint256 indexed poolId, address sourceCompany, string offenseCode, uint256 totalAmount, bool disasterMode);
    event ReliefPlanned(uint256 indexed poolId, address indexed communityTreasury, ReliefType reliefType, uint256 cashAmount, string notes);

    modifier onlySteward() { require(msg.sender == steward, "Not steward"); _; }
    modifier onlyRegulator() { require(regulators[msg.sender], "Not regulator"); _; }

    constructor() {
        steward = msg.sender;
        regulators[msg.sender] = true;
        severityHouseholdBps[uint8(Severity.Low)] = 5000;
        severityHouseholdBps[uint8(Severity.Medium)] = 6000;
        severityHouseholdBps[uint8(Severity.High)] = 7000;
        severityHouseholdBps[uint8(Severity.Critical)] = 8000;
    }

    function registerCompany(address id, address op, string calldata name) external onlySteward {
        companies[id] = Company(name, op, true);
        emit CompanyRegistered(id, op, name);
    }

    function registerOffense(string calldata code, string calldata description, Severity severity) external onlySteward {
        offenseCatalog[code] = Offense(code, description, severity, true);
        emit OffenseRegistered(code, description, severity);
    }

    function registerCommunity(address treasury, string calldata name, uint256 impactWeight) external onlySteward {
        communities[treasury] = Community(name, treasury, impactWeight, true);
        communityList.push(treasury);
        emit CommunityRegistered(treasury, name, impactWeight);
    }

    function setRegulator(address reg, bool status) external onlySteward {
        regulators[reg] = status;
    }

    /**
     * @dev Off-chain engine pre-computes ReliefPlan per community based on live needs.
     * Relief plan data is passed in by steward after AI forecast.
     */
    function logPenaltyWithRelief(
        address companyId,
        string calldata offenseCode,
        string calldata emotionalAPR,
        string calldata damayClause,
        bool disasterMode,
        uint16 disasterMultiplierBps,
        address[] calldata comms,
        ReliefType[] calldata reliefTypes,
        uint256[] calldata cashAmounts,
        string[] calldata notes
    ) external payable onlyRegulator {
        require(offenseCatalog[offenseCode].exists, "No offense");
        require(companies[companyId].registered, "Company not registered");
        require(msg.value > 0, "No penalty");
        require(comms.length == reliefTypes.length && comms.length == cashAmounts.length && comms.length == notes.length, "Array len mismatch");

        if (disasterMode) { require(disasterMultiplierBps >= BPS, "Multiplier too low"); }

        poolCount++;
        PoolDistribution storage pd = pools[poolCount];
        pd.totalAmount = msg.value;
        pd.emotionalAPR = emotionalAPR;
        pd.damayClause = damayClause;
        pd.sourceCompany = companyId;
        pd.offenseCode = offenseCode;
        pd.severity = offenseCatalog[offenseCode].severity;
        pd.disasterMode = disasterMode;
        pd.disasterMultiplierBps = disasterMultiplierBps;

        uint256 adjustedTotal = msg.value;
        if (disasterMode) { adjustedTotal = (msg.value * disasterMultiplierBps) / BPS; }

        // Assign relief per community
        for (uint256 i; i < comms.length; i++) {
            address t = comms[i];
            require(communities[t].active, "Inactive community");
            pd.reliefPerCommunity[t] = ReliefPlan(reliefTypes[i], cashAmounts[i], notes[i]);

            if (cashAmounts[i] > 0) {
                (bool ok, ) = payable(t).call{value: cashAmounts[i]}("");
                require(ok, "Treasury transfer failed");
            }
            emit ReliefPlanned(poolCount, t, reliefTypes[i], cashAmounts[i], notes[i]);
        }

        emit PenaltyPooled(poolCount, companyId, offenseCode, adjustedTotal, disasterMode);
    }
}
