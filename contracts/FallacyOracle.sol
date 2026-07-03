// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title FallacyOracle
/// @notice Covenant contract to safeguard portfolios through systemic anchoring of fallacy safeguards
contract FallacyOracle {
    address public overseer;
    uint256 public fallacyCount;

    struct FallacyRule {
        uint256 id;
        string fallacy; // Ad Hominem, Strawman, Slippery Slope, Appeal to Authority, etc.
        string context; // explanation of when valid or invalid
        uint256 timestamp;
    }

    mapping(uint256 => FallacyRule) public fallacies;

    event FallacyLogged(uint256 indexed id, string fallacy, string context);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logFallacy(
        string calldata fallacy,
        string calldata context
    ) external onlyOverseer {
        fallacyCount++;
        fallacies[fallacyCount] = FallacyRule({
            id: fallacyCount,
            fallacy: fallacy,
            context: context,
            timestamp: block.timestamp
        });
        emit FallacyLogged(fallacyCount, fallacy, context);
    }

    function viewFallacy(uint256 id) external view returns (FallacyRule memory) {
        return fallacies[id];
    }
}
