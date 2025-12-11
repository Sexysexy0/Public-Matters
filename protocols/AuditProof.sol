// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// AuditProof: civil society attestations (FGDs, street audits, PT infra checks)
contract AuditProof {
    struct Proof {
        uint256 id;
        string scope;       // e.g., "Bike lanes", "Pedestrian network"
        string evidenceURI; // photos, reports
        address auditor;    // validator or civil org address
        uint256 timestamp;
    }

    address public steward;
    mapping(address => bool) public validators;
    mapping(uint256 => Proof) public proofs;
    uint256 public nextId;

    event ValidatorAdded(address indexed validator);
    event ProofLogged(uint256 indexed id, string scope);

    constructor() {
        steward = msg.sender;
        validators[steward] = true;
        emit ValidatorAdded(steward);
    }

    function addValidator(address v) external {
        require(msg.sender == steward, "Only steward");
        validators[v] = true;
        emit ValidatorAdded(v);
    }

    function logProof(string calldata scope, string calldata evidenceURI) external {
        require(validators[msg.sender], "Not validator");
        proofs[nextId] = Proof(nextId, scope, evidenceURI, msg.sender, block.timestamp);
        emit ProofLogged(nextId, scope);
        nextId++;
    }
}
