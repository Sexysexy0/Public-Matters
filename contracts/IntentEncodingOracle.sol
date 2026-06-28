// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title IntentEncodingOracle
/// @notice Covenant contract to encode systemic will and intent for governance rituals
contract IntentEncodingOracle {
    address public overseer;
    uint256 public intentCount;

    struct IntentEntry {
        uint256 id;
        string actor;
        string will;
        string purpose;
        uint256 timestamp;
    }

    mapping(uint256 => IntentEntry) public intents;

    event IntentEncoded(uint256 indexed id, string actor, string will);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function encodeIntent(
        string calldata actor,
        string calldata will,
        string calldata purpose
    ) external onlyOverseer {
        intentCount++;
        intents[intentCount] = IntentEntry({
            id: intentCount,
            actor: actor,
            will: will,
            purpose: purpose,
            timestamp: block.timestamp
        });
        emit IntentEncoded(intentCount, actor, will);
    }

    function viewIntent(uint256 id) external view returns (IntentEntry memory) {
        return intents[id];
    }
}
