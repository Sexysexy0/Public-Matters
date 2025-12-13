// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// ComplianceGuard: record compliance checks and violations
contract ComplianceGuard {
    struct Check {
        uint256 id;
        string dataset;
        string regulation; // "EU Competition Law", "US Copyright Law"
        bool compliant;
        string notes;
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Check) public checks;
    mapping(address => bool) public stewards;

    event CheckLogged(uint256 indexed id, string dataset, bool compliant);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logCheck(string calldata dataset, string calldata regulation, bool compliant, string calldata notes) external {
        require(stewards[msg.sender], "Only steward");
        checks[nextId] = Check(nextId, dataset, regulation, compliant, notes, block.timestamp);
        emit CheckLogged(nextId, dataset, compliant);
        nextId++;
    }
}
