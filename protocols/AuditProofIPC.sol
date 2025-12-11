// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// AuditProofIPC: civil society attestations for IPC cases
contract AuditProofIPC {
    struct Proof {
        uint256 id;
        uint256 petitionId;
        string evidenceURI;
        address auditor;
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Proof) public proofs;
    mapping(address => bool) public validators;
    address public steward;

    event ProofLogged(uint256 indexed id, uint256 petitionId);

    constructor() {
        steward = msg.sender;
        validators[steward] = true;
    }

    function addValidator(address v) external {
        require(msg.sender == steward, "Only steward");
        validators[v] = true;
    }

    function logProof(uint256 petitionId, string calldata evidenceURI) external {
        require(validators[msg.sender], "Not validator");
        proofs[nextId] = Proof(nextId, petitionId, evidenceURI, msg.sender, block.timestamp);
        emit ProofLogged(nextId, petitionId);
        nextId++;
    }
}
