// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// ThreatInterpretationGuard: record interpretations of messages and flag them
contract ThreatInterpretationGuard {
    struct Interpretation {
        uint256 id;
        string messageText;
        string interpretedAs; // e.g., "Threat", "Neutral"
        address interpreter;
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Interpretation) public interpretations;
    mapping(address => bool) public stewards;

    event InterpretationLogged(uint256 indexed id, string interpretedAs);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logInterpretation(string calldata messageText, string calldata interpretedAs) external {
        require(stewards[msg.sender], "Only steward");
        interpretations[nextId] = Interpretation(nextId, messageText, interpretedAs, msg.sender, block.timestamp);
        emit InterpretationLogged(nextId, interpretedAs);
        nextId++;
    }
}
