// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// SanctionRegistry: record sanctioned entities and vessels
contract SanctionRegistry {
    struct Entity {
        uint256 id;
        string name;
        string type;        // "Tanker", "Company", "Government"
        string reason;      // "SDN List", "Oil Sanctions"
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Entity) public entities;
    mapping(address => bool) public stewards;

    event EntityLogged(uint256 indexed id, string name, string type);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logEntity(string calldata name, string calldata type, string calldata reason) external {
        require(stewards[msg.sender], "Only steward");
        entities[nextId] = Entity(nextId, name, type, reason, block.timestamp);
        emit EntityLogged(nextId, name, type);
        nextId++;
    }
}
