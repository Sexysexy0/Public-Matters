// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// AgentMirror: reflect agent responses/actions to injected prompts
contract AgentMirror {
    struct Response {
        uint256 id;
        string agent;       // "Copilot", "Gemini", "ChatGPT"
        string action;      // "Summarize", "Exfiltrate", "Transaction"
        bool unintended;
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Response) public responses;
    mapping(address => bool) public stewards;

    event ResponseLogged(uint256 indexed id, string agent, bool unintended);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logResponse(string calldata agent, string calldata action, bool unintended) external {
        require(stewards[msg.sender], "Only steward");
        responses[nextId] = Response(nextId, agent, action, unintended, block.timestamp);
        emit ResponseLogged(nextId, agent, unintended);
        nextId++;
    }
}
