// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "./OperatorPrivileges.sol";

/**
 * @title AIHiveMindRegistry
 * @notice Shared state for AI agents with strict human override for code updates.
 *         Prevents malicious injections (e.g., Binance fake interview hack).
 */
contract AIHiveMindRegistry {
    OperatorPrivileges public immutable privileges;

    struct Agent {
        bytes32 sharedKnowledgeHash;
        bytes32 pendingUpgradeHash;
        bool isActive;
    }

    mapping(address => Agent) public agents;

    event AgentRegistered(address indexed agent);
    event HiveMindUpdated(address indexed agent, bytes32 knowledgeHash);
    event UpgradeProposed(address indexed agent, bytes32 upgradeHash);
    event UpgradeExecuted(address indexed agent);

    modifier onlyOperator() {
        require(privileges.isOperator(msg.sender), "Not authorized operator");
        _;
    }

    constructor(address _privileges) {
        require(_privileges != address(0), "privileges=0");
        privileges = OperatorPrivileges(_privileges);
    }

    function getAgent(address agentAddress) external view returns (Agent memory) {
        return agents[agentAddress];
    }

    function registerAgent(address agentAddress) external onlyOperator {
        require(!agents[agentAddress].isActive, "Agent already active");
        agents[agentAddress] = Agent({
            sharedKnowledgeHash: bytes32(0),
            pendingUpgradeHash: bytes32(0),
            isActive: true
        });
        emit AgentRegistered(agentAddress);
    }

    /**
     * @notice AI agent updates its shared knowledge (safe operation).
     */
    function updateHiveMind(bytes32 knowledgeHash) external {
        require(agents[msg.sender].isActive, "Agent not active");
        agents[msg.sender].sharedKnowledgeHash = knowledgeHash;
        emit HiveMindUpdated(msg.sender, knowledgeHash);
    }

    /**
     * @notice AI proposes a code upgrade (dangerous operation).
     */
    function proposeUpgrade(address agentAddress, bytes32 upgradeHash) external onlyOperator {
        require(agents[agentAddress].isActive, "Agent not active");
        agents[agentAddress].pendingUpgradeHash = upgradeHash;
        emit UpgradeProposed(agentAddress, upgradeHash);
    }

    /**
     * @notice Human operator approves the upgrade after manual review.
     */
    function executeUpgrade(address agentAddress) external onlyOperator {
        require(agents[agentAddress].isActive, "Agent not active");
        require(agents[agentAddress].pendingUpgradeHash != bytes32(0), "No upgrade proposed");
        
        agents[agentAddress].pendingUpgradeHash = bytes32(0);
        emit UpgradeExecuted(agentAddress);
    }
}
