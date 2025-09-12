// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AICommandNode {
    struct Task {
        uint256 id;
        string operation;
        string assignedTo;
        string priority;
        uint256 timestamp;
        bool completed;
    }

    mapping(uint256 => Task) public taskLog;
    uint256 public taskCount;

    event TaskAssigned(uint256 id, string assignedTo);

    function assignTask(
        string memory operation,
        string memory assignedTo,
        string memory priority,
        uint256 timestamp
    ) public {
        taskLog[taskCount] = Task(
            taskCount, operation, assignedTo, priority, timestamp, false
        );
        emit TaskAssigned(taskCount, assignedTo);
        taskCount++;
    }

    function completeTask(uint256 id) public {
        taskLog[id].completed = true;
    }

    function getTask(uint256 id) public view returns (Task memory) {
        return taskLog[id];
    }
}
