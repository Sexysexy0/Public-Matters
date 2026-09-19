// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./OperatorPrivilegesV2.sol";

/**
 * @title AIAgentRegistryV2
 * @notice On-chain registry for AI agents with unified authorization.
 *         Fixes V1 issue: no separate admin variable.
 *         All auth flows through OperatorPrivilegesV2.
 */
contract AIAgentRegistryV2 {
    OperatorPrivilegesV2 public privileges;

    enum AgentStatus { INACTIVE, ACTIVE, SUSPENDED, KILLED }

    struct AIAgent {
        bytes32 agentId;
        string name;
        address agentOperator;
        string provenance;
        string[] capabilities;
        AgentStatus status;
        uint256 registeredAt;
        uint256 lastHeartbeat;
        uint256 killCount;
        uint256 violationCount;
    }

    mapping(bytes32 => AIAgent) public agents;
    bytes32[] public agentIds;

    mapping(address => bool) public killSwitchAuthorized;
    uint256 public heartbeatTolerance = 3600;

    event AgentRegistered(bytes32 indexed agentId, string name, address agentOperator);
    event AgentStatusChanged(bytes32 indexed agentId, AgentStatus status);
    event AgentKilled(bytes32 indexed agentId, string reason, address killer);
    event KillSwitchAuthorized(address indexed authority);
    event KillSwitchRevoked(address indexed authority);
    event Heartbeat(bytes32 indexed agentId, uint256 timestamp);
    event ViolationRecorded(bytes32 indexed agentId, string violation, uint256 count);
    event CapabilityAdded(bytes32 indexed agentId, string capability);
    event CapabilityRevoked(bytes32 indexed agentId, string capability);
    event HeartbeatToleranceUpdated(uint256 newTolerance);

    modifier onlyOperator() {
        require(privileges.isOperator(msg.sender), "Not authorized operator");
        _;
    }

    modifier onlyKillSwitch() {
        require(
            killSwitchAuthorized[msg.sender] || privileges.isOperator(msg.sender),
            "Not kill-switch authorized"
        );
        _;
    }

    modifier agentExists(bytes32 agentId) {
        require(agents[agentId].registeredAt != 0, "Agent not registered");
        _;
    }

    constructor(address _privileges) {
        require(_privileges != address(0), "Invalid privileges");
        privileges = OperatorPrivilegesV2(_privileges);
    }

    // ─── REGISTRATION ───

    function registerAgent(
        string calldata name,
        address agentOperator,
        string calldata provenance,
        string[] calldata capabilities
    ) external onlyOperator returns (bytes32) {
        bytes32 agentId = keccak256(
            abi.encodePacked(name, agentOperator, provenance, block.timestamp)
        );
        require(agents[agentId].registeredAt == 0, "Agent already registered");

        AIAgent storage a = agents[agentId];
        a.agentId = agentId;
        a.name = name;
        a.agentOperator = agentOperator;
        a.provenance = provenance;
        a.capabilities = capabilities;
        a.status = AgentStatus.ACTIVE;
        a.registeredAt = block.timestamp;
        a.lastHeartbeat = block.timestamp;

        agentIds.push(agentId);
        emit AgentRegistered(agentId, name, agentOperator);
        return agentId;
    }

    // ─── MONITORING ───

    function heartbeat(bytes32 agentId) external onlyOperator agentExists(agentId) {
        require(agents[agentId].status == AgentStatus.ACTIVE, "Agent not active");
        agents[agentId].lastHeartbeat = block.timestamp;
        emit Heartbeat(agentId, block.timestamp);
    }

    function recordViolation(bytes32 agentId, string calldata violation)
        external
        onlyOperator
        agentExists(agentId)
    {
        agents[agentId].violationCount++;
        emit ViolationRecorded(agentId, violation, agents[agentId].violationCount);
    }

    function isCompliant(bytes32 agentId) external view returns (bool) {
        AIAgent storage a = agents[agentId];
        if (a.registeredAt == 0) return false;
        if (a.status != AgentStatus.ACTIVE) return false;
        if (block.timestamp - a.lastHeartbeat > heartbeatTolerance) return false;
        return true;
    }

    // ─── STATUS ───

    function setStatus(bytes32 agentId, AgentStatus status)
        external
        onlyOperator
        agentExists(agentId)
    {
        agents[agentId].status = status;
        emit AgentStatusChanged(agentId, status);
    }

    function suspendAgent(bytes32 agentId, string calldata reason)
        external
        onlyKillSwitch
        agentExists(agentId)
    {
        agents[agentId].status = AgentStatus.SUSPENDED;
        emit AgentStatusChanged(agentId, AgentStatus.SUSPENDED);
        emit ViolationRecorded(agentId, reason, agents[agentId].violationCount);
    }

    function reactivateAgent(bytes32 agentId)
        external
        onlyKillSwitch
        agentExists(agentId)
    {
        require(agents[agentId].status == AgentStatus.SUSPENDED, "Agent not suspended");
        agents[agentId].status = AgentStatus.ACTIVE;
        agents[agentId].lastHeartbeat = block.timestamp;
        emit AgentStatusChanged(agentId, AgentStatus.ACTIVE);
    }

    // ─── KILL SWITCH ───

    function killAgent(bytes32 agentId, string calldata reason)
        external
        onlyKillSwitch
        agentExists(agentId)
    {
        agents[agentId].status = AgentStatus.KILLED;
        agents[agentId].killCount++;
        emit AgentKilled(agentId, reason, msg.sender);
        emit AgentStatusChanged(agentId, AgentStatus.KILLED);
    }

    // ─── CAPABILITIES ───

    function addCapability(bytes32 agentId, string calldata capability)
        external
        onlyOperator
        agentExists(agentId)
    {
        agents[agentId].capabilities.push(capability);
        emit CapabilityAdded(agentId, capability);
    }

    function revokeCapability(bytes32 agentId, string calldata capability)
        external
        onlyOperator
        agentExists(agentId)
    {
        string[] storage caps = agents[agentId].capabilities;
        for (uint256 i = 0; i < caps.length; i++) {
            if (keccak256(bytes(caps[i])) == keccak256(bytes(capability))) {
                caps[i] = caps[caps.length - 1];
                caps.pop();
                emit CapabilityRevoked(agentId, capability);
                return;
            }
        }
        revert("Capability not found");
    }

    // ─── AUTHORITY (all operator-gated — no separate admin) ───

    function authorizeKillSwitch(address authority) external onlyOperator {
        killSwitchAuthorized[authority] = true;
        emit KillSwitchAuthorized(authority);
    }

    function revokeKillSwitch(address authority) external onlyOperator {
        killSwitchAuthorized[authority] = false;
        emit KillSwitchRevoked(authority);
    }

    function setHeartbeatTolerance(uint256 newTolerance) external onlyOperator {
        require(newTolerance > 0, "Tolerance must be > 0");
        heartbeatTolerance = newTolerance;
        emit HeartbeatToleranceUpdated(newTolerance);
    }

    // ─── INVENTORY ───

    function getAgentInventory() external view returns (bytes32[] memory) {
        return agentIds;
    }

    function verifyProvenance(bytes32 agentId)
        external
        view
        agentExists(agentId)
        returns (string memory)
    {
        return agents[agentId].provenance;
    }

    function getAgent(bytes32 agentId)
        external
        view
        agentExists(agentId)
        returns (
            string memory name,
            address agentOperator,
            string memory provenance,
            string[] memory capabilities,
            AgentStatus status,
            uint256 registeredAt,
            uint256 lastHeartbeat,
            uint256 killCount,
            uint256 violationCount
        )
    {
        AIAgent storage a = agents[agentId];
        return (
            a.name,
            a.agentOperator,
            a.provenance,
            a.capabilities,
            a.status,
            a.registeredAt,
            a.lastHeartbeat,
            a.killCount,
            a.violationCount
        );
    }

    function totalAgents() external view returns (uint256) {
        return agentIds.length;
    }
}
