// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title TechParityProtocol
/// @notice Registry for global tech parity, breach-tiered innovation gaps, and ethical audit trails
/// @dev Anchors parity signals and emotional consequence tagging across sovereign corridors

contract TechParityProtocol {
    address public steward;
    mapping(address => bool) public auditors;

    modifier onlySteward() {
        require(msg.sender == steward, "Not steward");
        _;
    }

    modifier onlyAuditor() {
        require(auditors[msg.sender] || msg.sender == steward, "Not auditor");
        _;
    }

    enum ParityStatus {
        Behind,
        Matching,
        Surpassing,
        BreachDetected
    }

    struct Nation {
        string name;
        string region;
        bool active;
        uint256 registeredAt;
    }

    struct TechDeployment {
        uint256 id;
        address nation;
        string sector; // e.g., "AI", "Quantum", "Defense", "Cyber"
        string description;
        ParityStatus status;
        string breachTier; // e.g., "Ethical", "Transparency", "Civic Trust"
        string emotionalTag;
        uint256 createdAt;
        uint256 updatedAt;
    }

    uint256 public nextDeploymentId = 1;
    mapping(address => Nation) public nationRegistry;
    mapping(uint256 => TechDeployment) public deployments;
    mapping(address => uint256[]) public nationDeployments;

    event AuditorSet(address indexed account, bool status);
    event NationRegistered(address indexed account, string name, string region);
    event TechFiled(uint256 indexed id, address indexed nation, string sector, ParityStatus status);
    event ParityStatusUpdated(uint256 indexed id, ParityStatus status, string breachTier, string emotionalTag);

    constructor() {
        steward = msg.sender;
        auditors[msg.sender] = true;
        emit AuditorSet(msg.sender, true);
    }

    function setAuditor(address account, bool status) external onlySteward {
        auditors[account] = status;
        emit AuditorSet(account, status);
    }

    function registerNation(address account, string calldata name, string calldata region) external onlyAuditor {
        require(!nationRegistry[account].active, "Already registered");
        nationRegistry[account] = Nation({
            name: name,
            region: region,
            active: true,
            registeredAt: block.timestamp
        });
        emit NationRegistered(account, name, region);
    }

    function fileTechDeployment(
        address nation,
        string calldata sector,
        string calldata description,
        ParityStatus status,
        string calldata breachTier,
        string calldata emotionalTag
    ) external onlyAuditor returns (uint256 id) {
        require(nationRegistry[nation].active, "Nation not registered");
        id = nextDeploymentId++;
        deployments[id] = TechDeployment({
            id: id,
            nation: nation,
            sector: sector,
            description: description,
            status: status,
            breachTier: breachTier,
            emotionalTag: emotionalTag,
            createdAt: block.timestamp,
            updatedAt: block.timestamp
        });
        nationDeployments[nation].push(id);
        emit TechFiled(id, nation, sector, status);
        emit ParityStatusUpdated(id, status, breachTier, emotionalTag);
    }

    function updateParityStatus(
        uint256 id,
        ParityStatus status,
        string calldata breachTier,
        string calldata emotionalTag
    ) external onlyAuditor {
        TechDeployment storage td = deployments[id];
        require(td.id != 0, "Deployment not found");
        td.status = status;
        td.breachTier = breachTier;
        td.emotionalTag = emotionalTag;
        td.updatedAt = block.timestamp;
        emit ParityStatusUpdated(id, status, breachTier, emotionalTag);
    }

    function getNation(address account) external view returns (Nation memory) {
        return nationRegistry[account];
    }

    function getDeployment(uint256 id) external view returns (TechDeployment memory) {
        return deployments[id];
    }

    function listNationDeployments(address account) external view returns (uint256[] memory) {
        return nationDeployments[account];
    }
}
