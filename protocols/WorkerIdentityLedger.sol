// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// WorkerIdentityLedger: record worker identities and verification status
contract WorkerIdentityLedger {
    struct Worker {
        uint256 id;
        string name;
        string role;        // "Remote Developer", "Analyst"
        string status;      // "Verified", "Flagged"
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Worker) public workers;
    mapping(address => bool) public stewards;

    event WorkerLogged(uint256 indexed id, string name, string role, string status);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logWorker(string calldata name, string calldata role, string calldata status) external {
        require(stewards[msg.sender], "Only steward");
        workers[nextId] = Worker(nextId, name, role, status, block.timestamp);
        emit WorkerLogged(nextId, name, role, status);
        nextId++;
    }
}
