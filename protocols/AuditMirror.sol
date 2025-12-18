// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// AuditMirror: record actual inspection results
contract AuditMirror {
    struct Audit {
        uint256 id;
        string project;
        string finding;     // "Incomplete", "Unusable"
        string inspector;   // "Reporters Notebook"
        uint256 date;
    }

    uint256 public nextId;
    mapping(uint256 => Audit) public audits;
    mapping(address => bool) public stewards;

    event AuditLogged(uint256 indexed id, string project, string finding, string inspector);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logAudit(string calldata project, string calldata finding, string calldata inspector, uint256 date) external {
        require(stewards[msg.sender], "Only steward");
        audits[nextId] = Audit(nextId, project, finding, inspector, date);
        emit AuditLogged(nextId, project, finding, inspector);
        nextId++;
    }
}
