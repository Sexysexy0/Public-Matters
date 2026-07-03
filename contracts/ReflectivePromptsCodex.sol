// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title ReflectivePromptsCodex
/// @notice Covenant contract to safeguard leadership and personal growth through systemic anchoring of mindful reflection prompts
contract ReflectivePromptsCodex {
    address public overseer;
    uint256 public promptCount;

    struct PromptRule {
        uint256 id;
        string principle; // Self-Correction, Mindfulness, Daily Reflection, Growth
        string description; // encoded reflective safeguard
        uint256 timestamp;
    }

    mapping(uint256 => PromptRule) public prompts;

    event PromptLogged(uint256 indexed id, string principle, string description);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logPrompt(
        string calldata principle,
        string calldata description
    ) external onlyOverseer {
        promptCount++;
        prompts[promptCount] = PromptRule({
            id: promptCount,
            principle: principle,
            description: description,
            timestamp: block.timestamp
        });
        emit PromptLogged(promptCount, principle, description);
    }

    function viewPrompt(uint256 id) external view returns (PromptRule memory) {
        return prompts[id];
    }
}
