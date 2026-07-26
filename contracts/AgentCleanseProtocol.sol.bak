// AgentCleanseProtocol.sol
pragma solidity ^0.8.0;

contract AgentCleanseProtocol {
    struct Agent {
        uint256 id;
        string type;     // e.g. "Residual/Idle"
        string action;   // e.g. "Removed"
        uint256 timestamp;
    }

    uint256 public agentCount;
    mapping(uint256 => Agent) public agents;

    event AgentRemoved(uint256 id, string type, string action);

    function removeAgent(string memory type, string memory action) public {
        agentCount++;
        agents[agentCount] = Agent(agentCount, type, action, block.timestamp);
        emit AgentRemoved(agentCount, type, action);
    }
}
