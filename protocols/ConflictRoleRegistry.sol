// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// ConflictRoleRegistry: record roles of countries in conflicts (war vs mediation)
contract ConflictRoleRegistry {
    struct Role {
        uint256 id;
        string country;
        string role;       // e.g., "War participant", "Mediator"
        string conflict;   // e.g., "Ukraine-Russia", "Gaza"
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Role) public roles;
    mapping(address => bool) public stewards;

    event RoleLogged(uint256 indexed id, string country, string role);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logRole(string calldata country, string calldata role, string calldata conflict) external {
        require(stewards[msg.sender], "Only steward");
        roles[nextId] = Role(nextId, country, role, conflict, block.timestamp);
        emit RoleLogged(nextId, country, role);
        nextId++;
    }
}
