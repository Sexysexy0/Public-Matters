// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MemoryAuction {
    struct Action {
        string description;
        uint256 baseScore;
    }

    struct Memory {
        string eventDescription;
        int256 impact;
        uint256 timestamp;
    }

    struct Agent {
        uint256 id;
        string name;
        address owner; // NEW: owner for access control
        Action[] actions;
        Memory[] memories;
    }

    mapping(uint256 => Agent) private agents;
    uint256 private nextAgentId;

    event AgentCreated(uint256 indexed agentId, string name);
    event ActionAdded(uint256 indexed agentId, string description, uint256 baseScore);
    event MemoryRecorded(uint256 indexed agentId, string eventDescription, int256 impact);
    event DecisionMade(uint256 indexed agentId, string chosenAction);

    modifier onlyAgentOwner(uint256 agentId) {
        require(msg.sender == agents[agentId].owner, "Not owner");
        _;
    }

    function createAgent(string memory name) external returns (uint256) {
        require(bytes(name).length > 0, "Name empty"); // NEW: validation

        uint256 agentId = nextAgentId++;
        Agent storage agent = agents[agentId];
        agent.id = agentId;
        agent.name = name;
        agent.owner = msg.sender; // NEW: set owner
        emit AgentCreated(agentId, name);
        return agentId;
    }

    function addAction(uint256 agentId, string memory description, uint256 baseScore) external onlyAgentOwner(agentId) {
        require(bytes(description).length > 0, "Description empty"); // NEW: validation
        agents[agentId].actions.push(Action(description, baseScore));
        emit ActionAdded(agentId, description, baseScore);
    }

    function recordMemory(uint256 agentId, string memory eventDescription, int256 impact)
        external
        onlyAgentOwner(agentId)
    {
        require(bytes(eventDescription).length > 0, "Event empty"); // NEW: validation
        agents[agentId].memories.push(Memory(eventDescription, impact, block.timestamp));
        emit MemoryRecorded(agentId, eventDescription, impact);
    }

    function makeDecision(uint256 agentId) external view returns (string memory) {
        Agent storage agent = agents[agentId];
        require(agent.actions.length > 0, "No actions available");

        int256 bestScore = -1e18;
        string memory chosenAction;

        // NEW: Cache total memory impact for gas optimization
        int256 totalMemoryImpact = 0;
        for (uint256 j = 0; j < agent.memories.length; j++) {
            totalMemoryImpact += agent.memories[j].impact;
        }

        for (uint256 i = 0; i < agent.actions.length; i++) {
            int256 score = int256(agent.actions[i].baseScore) + totalMemoryImpact;

            if (score > bestScore) {
                bestScore = score;
                chosenAction = agent.actions[i].description;
            }
        }

        return chosenAction;
    }

    function getAgent(uint256 agentId) external view returns (string memory, uint256, uint256) {
        Agent storage agent = agents[agentId];
        return (agent.name, agent.actions.length, agent.memories.length);
    }

    function getAgentOwner(uint256 agentId) external view returns (address) {
        // NEW: helper
        return agents[agentId].owner;
    }
}
