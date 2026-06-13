// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title AgentOrchestration
/// @notice Covenant for swarm coordination of multiple agents
contract AgentOrchestration {
    address public oversightCommittee;
    uint256 public orchestrationCount;

    struct Orchestration {
        uint256 id;
        string agentGroup;   // e.g. memory, tool, analytics
        string task;         // description of coordinated task
        uint256 timestamp;
        bool executed;
    }

    mapping(uint256 => Orchestration) public orchestrations;

    event OrchestrationCreated(uint256 indexed id, string agentGroup, string task);
    event OrchestrationExecuted(uint256 indexed id, string agentGroup, string task);

    modifier onlyOversight() {
        require(msg.sender == oversightCommittee, "Not authorized");
        _;
    }

    constructor(address _oversightCommittee) {
        oversightCommittee = _oversightCommittee;
    }

    /// @notice Oversight creates orchestration task
    function createOrchestration(string calldata agentGroup, string calldata task) external onlyOversight {
        orchestrationCount++;
        orchestrations[orchestrationCount] = Orchestration({
            id: orchestrationCount,
            agentGroup: agentGroup,
            task: task,
            timestamp: block.timestamp,
            executed: false
        });
        emit OrchestrationCreated(orchestrationCount, agentGroup, task);
    }

    /// @notice Oversight executes orchestration task
    function executeOrchestration(uint256 id) external onlyOversight {
        Orchestration storage o = orchestrations[id];
        require(!o.executed, "Already executed");
        o.executed = true;
        emit OrchestrationExecuted(id, o.agentGroup, o.task);
    }
}
