// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// CoverageLedger: record universal insurance coverage
contract CoverageLedger {
    struct Coverage {
        uint256 id;
        string plan;        // "Universal Basic", "Extended"
        uint256 premium;    // monthly contribution
        uint256 benefits;   // coverage value in USD
        bool active;
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Coverage) public coverages;
    mapping(address => bool) public stewards;

    event CoverageLogged(uint256 indexed id, string plan, uint256 premium, uint256 benefits);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logCoverage(string calldata plan, uint256 premium, uint256 benefits, bool active) external {
        require(stewards[msg.sender], "Only steward");
        coverages[nextId] = Coverage(nextId, plan, premium, benefits, active, block.timestamp);
        emit CoverageLogged(nextId, plan, premium, benefits);
        nextId++;
    }
}
