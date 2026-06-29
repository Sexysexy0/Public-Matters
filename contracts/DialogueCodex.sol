// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title DialogueCodex
/// @notice Covenant contract to safeguard portfolios through systemic anchoring of civic dialogue safeguards
contract DialogueCodex {
    address public overseer;
    uint256 public dialogueCount;

    struct DialogueRule {
        uint256 id;
        string principle; // Respectful Exchange, Balanced Debate, Inclusive Participation, Conflict Resolution
        uint256 threshold; // safeguard value
        uint256 timestamp;
    }

    mapping(uint256 => DialogueRule) public dialogues;

    event DialogueLogged(uint256 indexed id, string principle, uint256 threshold);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logDialogue(
        string calldata principle,
        uint256 threshold
    ) external onlyOverseer {
        dialogueCount++;
        dialogues[dialogueCount] = DialogueRule({
            id: dialogueCount,
            principle: principle,
            threshold: threshold,
            timestamp: block.timestamp
        });
        emit DialogueLogged(dialogueCount, principle, threshold);
    }

    function viewDialogue(uint256 id) external view returns (DialogueRule memory) {
        return dialogues[id];
    }
}
