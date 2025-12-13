// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// LocalRegistry: record local road checkpoints (to be minimized)
contract LocalRegistry {
    struct LocalCheckpoint {
        uint256 id;
        string barangay;
        string street;
        bool active;
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => LocalCheckpoint) public localCheckpoints;
    mapping(address => bool) public stewards;

    event LocalCheckpointLogged(uint256 indexed id, string barangay, string street);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logLocalCheckpoint(string calldata barangay, string calldata street, bool active) external {
        require(stewards[msg.sender], "Only steward");
        localCheckpoints[nextId] = LocalCheckpoint(nextId, barangay, street, active, block.timestamp);
        emit LocalCheckpointLogged(nextId, barangay, street);
        nextId++;
    }
}
