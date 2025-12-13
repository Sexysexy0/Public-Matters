// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// ClaimMirror: record health insurance claims
contract ClaimMirror {
    struct Claim {
        uint256 id;
        uint256 beneficiaryId;
        string service;     // "Hospitalization", "Medicine", "Checkup"
        uint256 amount;
        string status;      // "Filed", "Approved", "Paid"
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Claim) public claims;
    mapping(address => bool) public stewards;

    event ClaimLogged(uint256 indexed id, uint256 beneficiaryId, string service, uint256 amount);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logClaim(uint256 beneficiaryId, string calldata service, uint256 amount, string calldata status) external {
        require(stewards[msg.sender], "Only steward");
        claims[nextId] = Claim(nextId, beneficiaryId, service, amount, status, block.timestamp);
        emit ClaimLogged(nextId, beneficiaryId, service, amount);
        nextId++;
    }
}
