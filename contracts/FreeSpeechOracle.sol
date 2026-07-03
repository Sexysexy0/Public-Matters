// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title FreeSpeechOracle
/// @notice Covenant contract to safeguard portfolios through systemic anchoring of free speech safeguards
contract FreeSpeechOracle {
    address public overseer;
    uint256 public speechCount;

    struct SpeechRule {
        uint256 id;
        string principle; // Open Expression, Balanced Moderation, Anti-Suppression, Civic Dialogue
        uint256 threshold; // safeguard value
        uint256 timestamp;
    }

    mapping(uint256 => SpeechRule) public speechRules;

    event SpeechLogged(uint256 indexed id, string principle, uint256 threshold);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logSpeech(
        string calldata principle,
        uint256 threshold
    ) external onlyOverseer {
        speechCount++;
        speechRules[speechCount] = SpeechRule({
            id: speechCount,
            principle: principle,
            threshold: threshold,
            timestamp: block.timestamp
        });
        emit SpeechLogged(speechCount, principle, threshold);
    }

    function viewSpeech(uint256 id) external view returns (SpeechRule memory) {
        return speechRules[id];
    }
}
