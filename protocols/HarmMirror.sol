// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// HarmMirror: record reputational or professional harm caused
contract HarmMirror {
    struct Harm {
        uint256 id;
        uint256 claimId;
        string harmType;   // "Reputation", "Career", "Financial"
        string description;
        uint256 severity;  // 1–10 scale
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Harm) public harms;
    mapping(address => bool) public stewards;

    event HarmLogged(uint256 indexed id, uint256 claimId, string harmType);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logHarm(uint256 claimId, string calldata harmType, string calldata description, uint256 severity) external {
        require(stewards[msg.sender], "Only steward");
        harms[nextId] = Harm(nextId, claimId, harmType, description, severity, block.timestamp);
        emit HarmLogged(nextId, claimId, harmType);
        nextId++;
    }
}
