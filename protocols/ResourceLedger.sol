// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// ResourceLedger: record resource profiles of allies
contract ResourceLedger {
    struct ResourceProfile {
        uint256 id;
        string country;
        string resource;   // e.g., "Natural gas", "None"
        uint256 value;     // approximate metric
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => ResourceProfile) public profiles;
    mapping(address => bool) public stewards;

    event ResourceLogged(uint256 indexed id, string country, string resource, uint256 value);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logResource(string calldata country, string calldata resource, uint256 value) external {
        require(stewards[msg.sender], "Only steward");
        profiles[nextId] = ResourceProfile(nextId, country, resource, value, block.timestamp);
        emit ResourceLogged(nextId, country, resource, value);
        nextId++;
    }
}
