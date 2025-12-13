// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// ImpactGuard: record social and environmental impacts of container factories
contract ImpactGuard {
    struct Impact {
        uint256 id;
        string category;   // "Jobs", "Carbon Reduction", "Housing Units"
        string description;
        uint256 value;
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Impact) public impacts;
    mapping(address => bool) public stewards;

    event ImpactLogged(uint256 indexed id, string category, uint256 value);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logImpact(string calldata category, string calldata description, uint256 value) external {
        require(stewards[msg.sender], "Only steward");
        impacts[nextId] = Impact(nextId, category, description, value, block.timestamp);
        emit ImpactLogged(nextId, category, value);
        nextId++;
    }
}
