// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// AuditProofPatch: civil/security team attestations of patch compliance
contract AuditProofPatch {
    struct Proof {
        uint256 id;
        string system;
        string evidenceURI; // logs, screenshots, reports
        address auditor;
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Proof) public proofs;
    mapping(address => bool) public auditors;
    address public steward;

    event ProofLogged(uint256 indexed id, string system);

    constructor() {
        steward = msg.sender;
        auditors[steward] = true;
    }

    function addAuditor(address a) external {
        require(msg.sender == steward, "Only steward");
        auditors[a] = true;
    }

    function logProof(string calldata system, string calldata evidenceURI) external {
        require(auditors[msg.sender], "Not auditor");
        proofs[nextId] = Proof(nextId, system, evidenceURI, msg.sender, block.timestamp);
        emit ProofLogged(nextId, system);
        nextId++;
    }
}
