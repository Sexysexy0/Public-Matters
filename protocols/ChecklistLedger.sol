// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// ChecklistLedger: track patch compliance tasks
contract ChecklistLedger {
    struct Task {
        uint256 id;
        string description; // e.g., "Upgrade API gateway to v2.3.1"
        bool completed;
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Task) public tasks;
    mapping(address => bool) public stewards;

    event TaskLogged(uint256 indexed id, string description);
    event TaskCompleted(uint256 indexed id);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logTask(string calldata description) external {
        require(stewards[msg.sender], "Only steward");
        tasks[nextId] = Task(nextId, description, false, block.timestamp);
        emit TaskLogged(nextId, description);
        nextId++;
    }

    function complete(uint256 id) external {
        require(stewards[msg.sender], "Only steward");
        tasks[id].completed = true;
        emit TaskCompleted(id);
    }
}
