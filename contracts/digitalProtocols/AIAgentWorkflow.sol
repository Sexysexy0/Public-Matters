// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title AIAgentWorkflow
/// @notice Encodes AI-human collaboration; delegates tasks to AI agents while preserving human oversight
contract AIAgentWorkflow {
    address public steward;

    struct Task {
        string description;
        bool isDataHeavy;
        bool requiresHumanJudgment;
        address assignedTo;
        bool completed;
    }

    Task[] public tasks;
    mapping(address => bool) public aiAgents;
    mapping(address => bool) public humanStewards;

    event TaskAssigned(uint indexed taskId, address indexed agent);
    event TaskCompleted(uint indexed taskId, address indexed agent);
    event AgentRegistered(address indexed agent, bool isAI);

    modifier onlySteward() {
        require(msg.sender == steward, "Not authorized");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function registerAgent(address _agent, bool _isAI) public onlySteward {
        if (_isAI) {
            aiAgents[_agent] = true;
        } else {
            humanStewards[_agent] = true;
        }
        emit AgentRegistered(_agent, _isAI);
    }

    function createTask(string memory _description, bool _isDataHeavy, bool _requiresHumanJudgment) public onlySteward {
        tasks.push(Task({
            description: _description,
            isDataHeavy: _isDataHeavy,
            requiresHumanJudgment: _requiresHumanJudgment,
            assignedTo: address(0),
            completed: false
        }));
    }

    function assignTask(uint _taskId, address _agent) public onlySteward {
        require(_taskId < tasks.length, "Invalid task ID");
        if (tasks[_taskId].isDataHeavy) {
            require(aiAgents[_agent], "Task requires AI agent");
        }
        if (tasks[_taskId].requiresHumanJudgment) {
            require(humanStewards[_agent], "Task requires human steward");
        }
        tasks[_taskId].assignedTo = _agent;
        emit TaskAssigned(_taskId, _agent);
    }

    function completeTask(uint _taskId) public {
        require(_taskId < tasks.length, "Invalid task ID");
        require(msg.sender == tasks[_taskId].assignedTo, "Not assigned to this task");
        tasks[_taskId].completed = true;
        emit TaskCompleted(_taskId, msg.sender);
    }

    function getTask(uint _taskId) public view returns (Task memory) {
        require(_taskId < tasks.length, "Invalid task ID");
        return tasks[_taskId];
    }
}
