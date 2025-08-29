// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title AutoPenaltyEscrowV8
 * @notice Adds Disaster-Mode multiplier and Relief-in-Kind option to cross-barangay pooling.
 */
contract AutoPenaltyEscrowV8 {
    address public steward;

    uint16 public constant BPS = 10_000;
    enum Severity { Low, Medium, High, Critical }

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

    struct PoolDistribution {
        uint256 totalAmount;
        string emotionalAPR;
        string damayClause;
        address sourceCompany;
        string offenseCode;
        Severity severity;
        bool disasterMode;
        uint16 disasterMultiplierBps;
        uint256 reliefInKindAmount;
        mapping(address => uint256) amountPerCommunity;
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
    event PenaltyPooled(uint256 indexed poolId, address sourceCompany, string offenseCode, uint256 totalAmount, bool disasterMode, uint256 reliefInKindAmount);

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

    function logPenaltyToPool(
        address companyId,
        string calldata offenseCode,
        string calldata emotionalAPR,
        string calldata damayClause,
        bool disasterMode,
        uint16 disasterMultiplierBps,
        uint256 reliefInKindAmount
    ) external payable onlyRegulator {
        require(offenseCatalog[offenseCode].exists, "No offense");
        require(companies[companyId].registered, "Company not registered");
        require(msg.value > 0, "No penalty");
        if (disasterMode) {
            require(disasterMultiplierBps >= BPS, "Multiplier too low");
        }

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
        pd.reliefInKindAmount = reliefInKindAmount;

        uint256 adjustedTotal = msg.value;
        if (disasterMode) {
            adjustedTotal = (msg.value * disasterMultiplierBps) / BPS;
        }

        uint256 totalWeight;
        for (uint256 i; i < communityList.length; i++) {
            if (communities[communityList[i]].active) {
                totalWeight += communities[communityList[i]].impactWeight;
            }
        }
        require(totalWeight > 0, "No active community");

        for (uint256 i; i < communityList.length; i++) {
            Community memory cm = communities[communityList[i]];
            if (cm.active) {
                uint256 share = (adjustedTotal * cm.impactWeight) / totalWeight;
                pd.amountPerCommunity[cm.treasury] = share;
                (bool ok, ) = payable(cm.treasury).call{value: share}("");
                require(ok, "Treasury transfer failed");
            }
        }

        emit PenaltyPooled(poolCount, companyId, offenseCode, adjustedTotal, disasterMode, reliefInKindAmount);
    }
}
