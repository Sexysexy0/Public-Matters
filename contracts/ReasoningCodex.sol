// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title ReasoningCodex
/// @notice Covenant contract to safeguard portfolios through systemic anchoring of pre-logic safeguards
contract ReasoningCodex {
    address public overseer;
    uint256 public reasoningCount;

    struct ReasoningRule {
        uint256 id;
        string principle; // Good vs Bad Arguments, Everyday Intuition, Contextual Fairness, Basic Rationality
        string description; // safeguard explanation
        uint256 timestamp;
    }

    mapping(uint256 => ReasoningRule) public reasonings;

    event ReasoningLogged(uint256 indexed id, string principle, string description);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logReasoning(
        string calldata principle,
        string calldata description
    ) external onlyOverseer {
        reasoningCount++;
        reasonings[reasoningCount] = ReasoningRule({
            id: reasoningCount,
            principle: principle,
            description: description,
            timestamp: block.timestamp
        });
        emit ReasoningLogged(reasoningCount, principle, description);
    }

    function viewReasoning(uint256 id) external view returns (ReasoningRule memory) {
        return reasonings[id];
    }
}
