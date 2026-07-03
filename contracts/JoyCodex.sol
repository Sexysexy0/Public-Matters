// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title JoyCodex
/// @notice Covenant contract to safeguard systemic joy, principled celebration, and dignified gladness
contract JoyCodex {
    address public overseer;
    uint256 public joyCount;

    struct JoyRule {
        uint256 id;
        string principle; // Joy, Celebration, Gladness, Hope
        string description; // encoded joy safeguard
        uint256 timestamp;
    }

    mapping(uint256 => JoyRule) public joys;

    event JoyLogged(uint256 indexed id, string principle, string description);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logJoy(
        string calldata principle,
        string calldata description
    ) external onlyOverseer {
        joyCount++;
        joys[joyCount] = JoyRule({
            id: joyCount,
            principle: principle,
            description: description,
            timestamp: block.timestamp
        });
        emit JoyLogged(joyCount, principle, description);
    }

    function viewJoy(uint256 id) external view returns (JoyRule memory) {
        return joys[id];
    }
}
