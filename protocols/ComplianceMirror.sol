// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// ComplianceMirror: record compliance of businesses with tax/VAT relief rules
contract ComplianceMirror {
    struct Compliance {
        uint256 id;
        string business;
        string sector;      // "Retail", "Transport", "Healthcare"
        bool compliant;
        string notes;
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Compliance) public compliances;
    mapping(address => bool) public stewards;

    event ComplianceLogged(uint256 indexed id, string business, bool compliant);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logCompliance(string calldata business, string calldata sector, bool compliant, string calldata notes) external {
        require(stewards[msg.sender], "Only steward");
        compliances[nextId] = Compliance(nextId, business, sector, compliant, notes, block.timestamp);
        emit ComplianceLogged(nextId, business, compliant);
        nextId++;
    }
}
