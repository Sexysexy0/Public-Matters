// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// SustainabilityProof: log environmental compliance and resilience metrics
contract SustainabilityProof {
    struct Proof {
        uint256 id;
        string project;
        string metric;      // e.g., "Carbon footprint", "Green space ratio"
        string evidenceURI; // reports, certifications
        address validator;
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Proof) public proofs;
    mapping(address => bool) public validators;
    address public steward;

    event ProofLogged(uint256 indexed id, string project, string metric);

    constructor() {
        steward = msg.sender;
        validators[steward] = true;
    }

    function addValidator(address v) external {
        require(msg.sender == steward, "Only steward");
        validators[v] = true;
    }

    function logProof(string calldata project, string calldata metric, string calldata evidenceURI) external {
        require(validators[msg.sender], "Not validator");
        proofs[nextId] = Proof(nextId, project, metric, evidenceURI, msg.sender, block.timestamp);
        emit ProofLogged(nextId, project, metric);
        nextId++;
    }
}
