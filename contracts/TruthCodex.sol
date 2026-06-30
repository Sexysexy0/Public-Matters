// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title TruthCodex
/// @notice Covenant contract to safeguard systemic integrity, factual clarity, and dignified truth
contract TruthCodex {
    address public overseer;
    uint256 public truthCount;

    struct TruthRule {
        uint256 id;
        string principle; // Integrity, Factual Clarity, Transparency, Anti-Deception
        string description; // encoded truth safeguard
        uint256 timestamp;
    }

    mapping(uint256 => TruthRule) public truths;

    event TruthLogged(uint256 indexed id, string principle, string description);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logTruth(
        string calldata principle,
        string calldata description
    ) external onlyOverseer {
        truthCount++;
        truths[truthCount] = TruthRule({
            id: truthCount,
            principle: principle,
            description: description,
            timestamp: block.timestamp
        });
        emit TruthLogged(truthCount, principle, description);
    }

    function viewTruth(uint256 id) external view returns (TruthRule memory) {
        return truths[id];
    }
}
