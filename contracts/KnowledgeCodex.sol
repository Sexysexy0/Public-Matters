// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title KnowledgeCodex
/// @notice Covenant contract to safeguard systemic wisdom, enlightened learning, and dignified knowledge
contract KnowledgeCodex {
    address public overseer;
    uint256 public knowledgeCount;

    struct KnowledgeRule {
        uint256 id;
        string principle; // Wisdom, Learning, Discernment, Enlightenment
        string description; // encoded knowledge safeguard
        uint256 timestamp;
    }

    mapping(uint256 => KnowledgeRule) public knowledges;

    event KnowledgeLogged(uint256 indexed id, string principle, string description);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logKnowledge(
        string calldata principle,
        string calldata description
    ) external onlyOverseer {
        knowledgeCount++;
        knowledges[knowledgeCount] = KnowledgeRule({
            id: knowledgeCount,
            principle: principle,
            description: description,
            timestamp: block.timestamp
        });
        emit KnowledgeLogged(knowledgeCount, principle, description);
    }

    function viewKnowledge(uint256 id) external view returns (KnowledgeRule memory) {
        return knowledges[id];
    }
}
