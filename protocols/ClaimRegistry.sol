// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// ClaimRegistry: record benefit claims filed by contributors
contract ClaimRegistry {
    struct Claim {
        uint256 id;
        string claimant;
        string benefit;     // "Retirement", "Disability", "Loan"
        string status;      // "Processing", "Approved", "Denied"
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Claim) public claims;
    mapping(address => bool) public stewards;

    event ClaimLogged(uint256 indexed id, string claimant, string benefit, string status);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logClaim(string calldata claimant, string calldata benefit, string calldata status) external {
        require(stewards[msg.sender], "Only steward");
        claims[nextId] = Claim(nextId, claimant, benefit, status, block.timestamp);
        emit ClaimLogged(nextId, claimant, benefit, status);
        nextId++;
    }
}
