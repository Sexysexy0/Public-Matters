// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title MemoryAuction
 * @dev A contract that models decision-making with memory.
 * Agents bid on actions with scores. Scores are adjusted based on
 * remembered events (positive or negative outcomes).
 */
contract MemoryAuction {
    struct Action {
        string description;
        uint256 baseScore;
    }

    struct Memory {
        string eventDescription;
        int256 impact; // positive or negative adjustment
        uint256 timestamp;
    }

    struct Agent {
        uint256 id;
        string name;
        Action[] actions;
        Memory[] memories;
    }

    mapping(uint256 => Agent) private agents;
    uint256 private nextAgentId;

    event AgentCreated(uint256 indexed agentId, string name);
    event ActionAdded(uint256 indexed agentId, string description, uint256 baseScore);
    event MemoryRecorded(uint256 indexed agentId, string eventDescription, int256 impact);
    event DecisionMade(uint256 indexed agentId, string chosenAction);

    function createAgent(string memory name) external returns (uint256) {
        uint256 agentId = nextAgentId++;
        Agent storage agent = agents[agentId];
        agent.id = agentId;
        agent.name = name;
        emit AgentCreated(agentId, name);
        return agentId;
    }

    function addAction(uint256 agentId, string memory description, uint256 baseScore) external {
        agents[agentId].actions.push(Action(description, baseScore));
        emit ActionAdded(agentId, description, baseScore);
    }

    function recordMemory(uint256 agentId, string memory eventDescription, int256 impact) external {
        agents[agentId].memories.push(Memory(eventDescription, impact, block.timestamp));
        emit MemoryRecorded(agentId, eventDescription, impact);
    }

    function makeDecision(uint256 agentId) external returns (string memory) {
        Agent storage agent = agents[agentId];
        require(agent.actions.length > 0, "No actions available");

        int256 bestScore = -1e18;
        string memory chosenAction;

        for (uint256 i = 0; i < agent.actions.length; i++) {
            int256 score = int256(agent.actions[i].baseScore);

            for (uint256 j = 0; j < agent.memories.length; j++) {
                score += agent.memories[j].impact;
            }

            if (score > bestScore) {
                bestScore = score;
                chosenAction = agent.actions[i].description;
            }
        }

        emit DecisionMade(agentId, chosenAction);
        return chosenAction;
    }

    function getAgent(uint256 agentId) external view returns (string memory, uint256, uint256) {
        Agent storage agent = agents[agentId];
        return (agent.name, agent.actions.length, agent.memories.length);
    }
}
