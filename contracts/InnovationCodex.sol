// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title InnovationCodex
/// @notice Covenant contract to safeguard systemic creativity, breakthrough, and dignified innovation
contract InnovationCodex {
    address public overseer;
    uint256 public innovationCount;

    struct InnovationRule {
        uint256 id;
        string principle; // Creativity, Breakthrough, Visionary Thinking, Systemic Renewal
        string description; // encoded innovation safeguard
        uint256 timestamp;
    }

    mapping(uint256 => InnovationRule) public innovations;

    event InnovationLogged(uint256 indexed id, string principle, string description);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logInnovation(
        string calldata principle,
        string calldata description
    ) external onlyOverseer {
        innovationCount++;
        innovations[innovationCount] = InnovationRule({
            id: innovationCount,
            principle: principle,
            description: description,
            timestamp: block.timestamp
        });
        emit InnovationLogged(innovationCount, principle, description);
    }

    function viewInnovation(uint256 id) external view returns (InnovationRule memory) {
        return innovations[id];
    }
}
