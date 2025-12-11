// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// WorkRegistry: log jobs, livelihoods, and tool access
contract WorkRegistry {
    struct Work {
        uint256 id;
        address worker;
        string role;        // e.g., "Rider", "Tech", "Vendor"
        string proofURI;    // contract, coop membership, permits
        bool active;
        uint256 incomeTarget; // monthly target in pesos
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Work) public works;
    mapping(address => bool) public stewards;

    event WorkLogged(uint256 indexed id, address worker, string role);
    event WorkUpdated(uint256 indexed id, bool active, uint256 incomeTarget);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logWork(address worker, string calldata role, string calldata proofURI, bool active, uint256 incomeTarget) external {
        require(stewards[msg.sender], "Only steward");
        works[nextId] = Work(nextId, worker, role, proofURI, active, incomeTarget, block.timestamp);
        emit WorkLogged(nextId, worker, role);
        nextId++;
    }

    function update(uint256 id, bool active, uint256 incomeTarget) external {
        require(stewards[msg.sender], "Only steward");
        Work storage w = works[id];
        w.active = active;
        w.incomeTarget = incomeTarget;
        emit WorkUpdated(id, active, incomeTarget);
    }
}
