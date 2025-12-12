// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// TrustAudit: record transparency audits of premium member services
contract TrustAudit {
    struct Audit {
        uint256 id;
        string category;     // e.g., "Loan release", "Rate policy"
        string evidenceURI;
        address auditor;
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Audit) public audits;
    mapping(address => bool) public auditors;
    address public steward;

    event AuditLogged(uint256 indexed id, string category);

    constructor() {
        steward = msg.sender;
        auditors[steward] = true;
    }

    function addAuditor(address a) external {
        require(msg.sender == steward, "Only steward");
        auditors[a] = true;
    }

    function logAudit(string calldata category, string calldata evidenceURI) external {
        require(auditors[msg.sender], "Not auditor");
        audits[nextId] = Audit(nextId, category, evidenceURI, msg.sender, block.timestamp);
        emit AuditLogged(nextId, category);
        nextId++;
    }
}
