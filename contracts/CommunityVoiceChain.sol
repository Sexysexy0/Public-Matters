// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CommunityVoiceChain {
    address public overseer;
    uint256 public voiceCount;

    struct Voice {
        uint256 id;
        string community;
        string statement;
        uint256 timestamp;
    }

    mapping(uint256 => Voice) public voices;
    event VoiceRecorded(uint256 indexed id, string community, string statement);

    constructor(address _overseer) {
        overseer = _overseer;
    }

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    function recordVoice(string calldata community, string calldata statement) external onlyOverseer {
        voiceCount++;
        voices[voiceCount] = Voice(voiceCount, community, statement, block.timestamp);
        emit VoiceRecorded(voiceCount, community, statement);
    }
}
