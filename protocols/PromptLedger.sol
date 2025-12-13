// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// PromptLedger: record injected prompts
contract PromptLedger {
    struct Prompt {
        uint256 id;
        string source;      // "Email", "Website", "Document"
        string content;
        bool malicious;
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Prompt) public prompts;
    mapping(address => bool) public stewards;

    event PromptLogged(uint256 indexed id, string source, bool malicious);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logPrompt(string calldata source, string calldata content, bool malicious) external {
        require(stewards[msg.sender], "Only steward");
        prompts[nextId] = Prompt(nextId, source, content, malicious, block.timestamp);
        emit PromptLogged(nextId, source, malicious);
        nextId++;
    }
}
