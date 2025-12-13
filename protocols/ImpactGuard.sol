// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// ImpactGuard: record social and economic impacts of national railway expansion
contract ImpactGuard {
    struct Impact {
        uint256 id;
        string route;
        string category;   // "Jobs", "Travel Time Reduction", "Regional Growth"
        uint256 value;
        string description;
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Impact) public impacts;
    mapping(address => bool) public stewards;

    event ImpactLogged(uint256 indexed id, string route, string category, uint256 value);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logImpact(string calldata route, string calldata category, uint256 value, string calldata description) external {
        require(stewards[msg.sender], "Only steward");
        impacts[nextId] = Impact(nextId, route, category, value, description, block.timestamp);
        emit ImpactLogged(nextId, route, category, value);
        nextId++;
    }
}
