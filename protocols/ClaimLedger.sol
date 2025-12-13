// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// ClaimLedger: record defamation claims
contract ClaimLedger {
    struct Claim {
        uint256 id;
        string claimant;   // e.g., "Cash Patel"
        string respondent; // e.g., "MSNBC"
        string allegation; // summary of false statement
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Claim) public claims;
    mapping(address => bool) public stewards;

    event ClaimLogged(uint256 indexed id, string claimant, string respondent);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logClaim(string calldata claimant, string calldata respondent, string calldata allegation) external {
        require(stewards[msg.sender], "Only steward");
        claims[nextId] = Claim(nextId, claimant, respondent, allegation, block.timestamp);
        emit ClaimLogged(nextId, claimant, respondent);
        nextId++;
    }
}
