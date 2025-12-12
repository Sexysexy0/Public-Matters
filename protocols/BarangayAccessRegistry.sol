// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// BarangayAccessRegistry: record barangay-level access lines
contract BarangayAccessRegistry {
    struct AccessLine {
        uint256 id;
        string barangay;
        string hub;        // nearest city hub
        bool active;
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => AccessLine) public lines;
    mapping(address => bool) public stewards;

    event AccessLineLogged(uint256 indexed id, string barangay, string hub);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logAccessLine(string calldata barangay, string calldata hub, bool active) external {
        require(stewards[msg.sender], "Only steward");
        lines[nextId] = AccessLine(nextId, barangay, hub, active, block.timestamp);
        emit AccessLineLogged(nextId, barangay, hub);
        nextId++;
    }
}
