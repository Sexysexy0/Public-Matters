// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// LiabilityGuard: record accountability for incomplete or missed upgrades
contract LiabilityGuard {
    struct Liability {
        uint256 id;
        string system;
        string issue;       // e.g., "Incomplete fix for CVE-2025-55184"
        address responsible;
        bool resolved;
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Liability) public liabilities;
    mapping(address => bool) public stewards;

    event LiabilityLogged(uint256 indexed id, string system, string issue);
    event LiabilityResolved(uint256 indexed id);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logLiability(string calldata system, string calldata issue, address responsible) external {
        require(stewards[msg.sender], "Only steward");
        liabilities[nextId] = Liability(nextId, system, issue, responsible, false, block.timestamp);
        emit LiabilityLogged(nextId, system, issue);
        nextId++;
    }

    function resolve(uint256 id) external {
        require(stewards[msg.sender], "Only steward");
        liabilities[id].resolved = true;
        emit LiabilityResolved(id);
    }
}
