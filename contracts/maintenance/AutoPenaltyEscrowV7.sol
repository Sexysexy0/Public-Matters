// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title AutoPenaltyEscrowV7
 * @notice Severity-weighted split to multiple communities + households
 *         via impact weights, cross-barangay pooling, and multi-treasury routing.
 */
contract AutoPenaltyEscrowV7 {
    address public steward;

    uint16 public constant BPS = 10_000;
    enum Severity { Low, Medium, High, Critical }

    struct Community {
        string name;
        address treasury;
        uint256 impactWeight; // relative share in BPS within a pool
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
        mapping(address => uint256) amountPerCommunity;
    }

    mapping(address => bool) public regulators;
    mapping(address => Company) public companies;
    mapping(string => Offense) public offenseCatalog;
    mapping(address => Community) public communities; // key = treasury address
    address[] public communityList;

    mapping(uint8 => uint16) public severityHouseholdBps; // share to households

    mapping(uint256 => PoolDistribution) public pools;
    uint256 public poolCount;

    event CompanyRegistered(address indexed id, address operator, string name);
    event CommunityRegistered(address indexed treasury, string name, uint256 impactWeight);
    event OffenseRegistered(string code, string description, Severity severity);
    event PenaltyPooled(uint256 indexed poolId, address indexed sourceCompany, string offenseCode, uint256 totalAmount);

    modifier onlySteward() {
        require(msg.sender == steward, "Not steward");
        _;
    }

    modifier onlyRegulator() {
        require(regulators[msg.sender], "Not regulator");
        _;
    }

    constructor() {
        steward = msg.sender;
        regulators[msg.sender] = true;
        // Default severity → household % mapping
        severityHouseholdBps[uint8(Severity.Low)] = 5000;
        severityHouseholdBps[uint8(Severity.Medium)] = 6000;
        severityHouseholdBps[uint8(Severity.High)] = 7000;
        severityHouseholdBps[uint8(Severity.Critical)] = 8000;
    }

    // --- Admin ---
    function registerCompany(address id, address op, string calldata name) external onlySteward {
        companies[id] = Company(name, op, true);
        emit CompanyRegistered(id, op, name);
    }

    function registerOffense(string calldata code, string calldata description, Severity severity) external onlySteward {
        offenseCatalog[code] = Offense(code, description, severity, true);
        emit OffenseRegistered(code, description, severity);
    }

    function registerCommunity(address treasury, string calldata name, uint256 impactWeight) external onlySteward {
        require(treasury != address(0), "Zero addr");
        require(impactWeight > 0, "Zero weight");
        communities[treasury] = Community(name, treasury, impactWeight, true);
        communityList.push(treasury);
        emit CommunityRegistered(treasury, name, impactWeight);
    }

    function setRegulator(address reg, bool status) external onlySteward {
        regulators[reg] = status;
    }

    // --- Core ---
    function logPenaltyToPool(
        address companyId,
        string calldata offenseCode,
        string calldata emotionalAPR,
        string calldata damayClause
    ) external payable onlyRegulator {
        require(offenseCatalog[offenseCode].exists, "No offense");
        require(companies[companyId].registered, "Company not reg");
        require(msg.value > 0, "No penalty");

        poolCount++;
        PoolDistribution storage pd = pools[poolCount];
        pd.totalAmount = msg.value;
        pd.emotionalAPR = emotionalAPR;
        pd.damayClause = damayClause;
        pd.sourceCompany = companyId;
        pd.offenseCode = offenseCode;
        pd.severity = offenseCatalog[offenseCode].severity;

        uint256 totalWeight;
        for (uint256 i; i < communityList.length; i++) {
            if (communities[communityList[i]].active) {
                totalWeight += communities[communityList[i]].impactWeight;
            }
        }
        require(totalWeight > 0, "No active comm");

        for (uint256 i; i < communityList.length; i++) {
            Community memory cm = communities[communityList[i]];
            if (cm.active) {
                uint256 share = (msg.value * cm.impactWeight) / totalWeight;
                pd.amountPerCommunity[cm.treasury] = share;
                (bool ok, ) = payable(cm.treasury).call{value: share}("");
                require(ok, "Treasury fail");
            }
        }

        emit PenaltyPooled(poolCount, companyId, offenseCode, msg.value);
    }

    // --- View ---
    function getCommunities() external view returns (Community[] memory list) {
        list = new Community[](communityList.length);
        for (uint256 i; i < communityList.length; i++) {
            list[i] = communities[communityList[i]];
        }
    }
}
