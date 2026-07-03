// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title ConsumerVoiceBridge
/// @notice Covenant contract to safeguard portfolios through systemic anchoring of consumer voice safeguards
contract ConsumerVoiceBridge {
    address public overseer;
    uint256 public voiceCount;

    struct VoiceRule {
        uint256 id;
        string principle; // Consumer Choice, Market Feedback, Wallet Leverage, Civic Expression
        uint256 threshold; // safeguard value
        uint256 timestamp;
    }

    mapping(uint256 => VoiceRule) public voices;

    event VoiceLogged(uint256 indexed id, string principle, uint256 threshold);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logVoice(
        string calldata principle,
        uint256 threshold
    ) external onlyOverseer {
        voiceCount++;
        voices[voiceCount] = VoiceRule({
            id: voiceCount,
            principle: principle,
            threshold: threshold,
            timestamp: block.timestamp
        });
        emit VoiceLogged(voiceCount, principle, threshold);
    }

    function viewVoice(uint256 id) external view returns (VoiceRule memory) {
        return voices[id];
    }
}
