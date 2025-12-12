// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// TransparencyAuditProof: public audit trail of fund uses, investments, and returns
contract TransparencyAuditProof {
    struct Audit {
        uint256 id;
        string category;     // e.g., "Investments", "Benefits", "Operating expenses"
        uint256 amount;      // pesos
        string evidenceURI;  // statements, reports
        address auditor;
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Audit) public audits;
    mapping(address => bool) public auditors;
    address public steward;

    event AuditLogged(uint256 indexed id, string category, uint256 amount);

    constructor() {
        steward = msg.sender;
        auditors[steward] = true;
    }

    function addAuditor(address a) external {
        require(msg.sender == steward, "Only steward");
        auditors[a] = true;
    }

    function logAudit(string calldata category, uint256 amount, string calldata evidenceURI) external {
        require(auditors[msg.sender], "Not auditor");
        audits[nextId] = Audit(nextId, category, amount, evidenceURI, msg.sender, block.timestamp);
        emit AuditLogged(nextId, category, amount);
        nextId++;
    }
}
