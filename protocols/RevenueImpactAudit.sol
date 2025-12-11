// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// RevenueImpactAudit: track government revenue impact of VAT exemptions
contract RevenueImpactAudit {
    struct Audit {
        uint256 id;
        string item;
        uint256 foregoneRevenue; // in pesos
        string evidenceURI;
        address auditor;
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Audit) public audits;
    mapping(address => bool) public auditors;
    address public steward;

    event AuditLogged(uint256 indexed id, string item, uint256 foregoneRevenue);

    constructor() {
        steward = msg.sender;
        auditors[steward] = true;
    }

    function addAuditor(address a) external {
        require(msg.sender == steward, "Only steward");
        auditors[a] = true;
    }

    function logAudit(string calldata item, uint256 foregoneRevenue, string calldata evidenceURI) external {
        require(auditors[msg.sender], "Not auditor");
        audits[nextId] = Audit(nextId, item, foregoneRevenue, evidenceURI, msg.sender, block.timestamp);
        emit AuditLogged(nextId, item, foregoneRevenue);
        nextId++;
    }
}
