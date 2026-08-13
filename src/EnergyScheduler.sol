// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

contract EnergyScheduler {
    enum EnergyType { Physical, Mental, Emotional }

    struct Task {
        string description;
        EnergyType required;
        address assignee;
    }

    Task[] public tasks;

    event TaskAssigned(string description, EnergyType required, address assignee);

    function assignTask(string calldata description, EnergyType required, address assignee) external {
        tasks.push(Task(description, required, assignee));
        emit TaskAssigned(description, required, assignee);
    }

    function totalTasks() external view returns (uint256) {
        return tasks.length;
    }
}
