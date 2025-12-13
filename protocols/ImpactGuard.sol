// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// ImpactGuard: record social and economic impacts of spare parts manufacturing
contract ImpactGuard {
    struct Impact {
        uint256 id;
        string category;   // "Jobs", "Exports", "Customization Culture"
        uint256 value;
        string description;
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

    function logImpact(string calldata category, uint256 value, string calldata description) external {
        require(stewards[msg.sender], "Only steward");
        impacts[nextId] = Impact(nextId, category, value, description, block.timestamp);
        emit ImpactLogged(nextId, category, value);
        nextId++;
    }
}
