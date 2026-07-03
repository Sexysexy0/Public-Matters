// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title LoveCodex
/// @notice Covenant contract to safeguard systemic affection, principled compassion, and dignified love
contract LoveCodex {
    address public overseer;
    uint256 public loveCount;

    struct LoveRule {
        uint256 id;
        string principle; // Love, Compassion, Affection, Unity
        string description; // encoded love safeguard
        uint256 timestamp;
    }

    mapping(uint256 => LoveRule) public loves;

    event LoveLogged(uint256 indexed id, string principle, string description);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logLove(
        string calldata principle,
        string calldata description
    ) external onlyOverseer {
        loveCount++;
        loves[loveCount] = LoveRule({
            id: loveCount,
            principle: principle,
            description: description,
            timestamp: block.timestamp
        });
        emit LoveLogged(loveCount, principle, description);
    }

    function viewLove(uint256 id) external view returns (LoveRule memory) {
        return loves[id];
    }
}
