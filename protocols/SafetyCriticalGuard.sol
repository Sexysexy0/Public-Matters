// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// SafetyCriticalGuard: tag roles as safety-critical and apply stricter rules
contract SafetyCriticalGuard {
    struct Role {
        uint256 id;
        string name;        // e.g., "Forklift operator", "Truck driver"
        bool safetyCritical;
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Role) public roles;
    mapping(address => bool) public stewards;

    event RoleSet(uint256 indexed id, string name, bool safetyCritical);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function setRole(string calldata name, bool safetyCritical) external {
        require(stewards[msg.sender], "Only steward");
        roles[nextId] = Role(nextId, name, safetyCritical, block.timestamp);
        emit RoleSet(nextId, name, safetyCritical);
        nextId++;
    }

    function update(uint256 id, bool safetyCritical) external {
        require(stewards[msg.sender], "Only steward");
        roles[id].safetyCritical = safetyCritical;
    }
}
