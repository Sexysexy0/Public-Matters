// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// EvidenceRegistry: record supporting evidence for claims
contract EvidenceRegistry {
    struct Evidence {
        uint256 id;
        uint256 claimId;
        string type;       // "Witness", "Document", "Video"
        string description;
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Evidence) public evidences;
    mapping(address => bool) public stewards;

    event EvidenceLogged(uint256 indexed id, uint256 claimId, string type);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logEvidence(uint256 claimId, string calldata type, string calldata description) external {
        require(stewards[msg.sender], "Only steward");
        evidences[nextId] = Evidence(nextId, claimId, type, description, block.timestamp);
        emit EvidenceLogged(nextId, claimId, type);
        nextId++;
    }
}
