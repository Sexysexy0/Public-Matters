// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// CivicAuditLedger: record civil society audits and feedback
contract CivicAuditLedger {
    struct Audit {
        uint256 id;
        string project;
        string findingsURI; // FGD notes, street audit reports
        address auditor;
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Audit) public audits;
    mapping(address => bool) public validators;
    address public steward;

    event AuditLogged(uint256 indexed id, string project);

    constructor() {
        steward = msg.sender;
        validators[steward] = true;
    }

    function addValidator(address v) external {
        require(msg.sender == steward, "Only steward");
        validators[v] = true;
    }

    function logAudit(string calldata project, string calldata findingsURI) external {
        require(validators[msg.sender], "Not validator");
        audits[nextId] = Audit(nextId, project, findingsURI, msg.sender, block.timestamp);
        emit AuditLogged(nextId, project);
        nextId++;
    }
}
