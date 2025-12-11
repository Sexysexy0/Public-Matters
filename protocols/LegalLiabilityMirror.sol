// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// LegalLiabilityMirror: map employer, agency, and worker liabilities to policy choices
contract LegalLiabilityMirror {
    struct Liability {
        uint256 id;
        string role;          // role in question
        string substance;     // e.g., "THC"
        string jurisdiction;  // e.g., "PH"
        string basisURI;      // laws, guidance
        bool compliant;       // policy vs law compliance flag
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Liability) public liabilities;
    mapping(address => bool) public stewards;

    event LiabilityLogged(uint256 indexed id, string role, string substance, bool compliant);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logLiability(string calldata role, string calldata substance, string calldata jurisdiction, string calldata basisURI, bool compliant) external {
        require(stewards[msg.sender], "Only steward");
        liabilities[nextId] = Liability(nextId, role, substance, jurisdiction, basisURI, compliant, block.timestamp);
        emit LiabilityLogged(nextId, role, substance, compliant);
        nextId++;
    }
}
