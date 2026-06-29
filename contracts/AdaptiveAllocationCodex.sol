// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title AdaptiveAllocationCodex
/// @notice Covenant contract to safeguard portfolios through systemic anchoring of adaptive allocation safeguards
contract AdaptiveAllocationCodex {
    address public overseer;
    uint256 public adaptiveCount;

    struct AdaptiveRule {
        uint256 id;
        string bucket; // Core, Satellite, Safety
        string triggerMetric; // Volatility, Liquidity, Market Trend, Risk Index
        string adjustment; // Increase, Decrease, Rebalance
        uint256 timestamp;
    }

    mapping(uint256 => AdaptiveRule) public adaptiveRules;

    event AdaptiveLogged(uint256 indexed id, string bucket, string triggerMetric, string adjustment);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logAdaptive(
        string calldata bucket,
        string calldata triggerMetric,
        string calldata adjustment
    ) external onlyOverseer {
        adaptiveCount++;
        adaptiveRules[adaptiveCount] = AdaptiveRule({
            id: adaptiveCount,
            bucket: bucket,
            triggerMetric: triggerMetric,
            adjustment: adjustment,
            timestamp: block.timestamp
        });
        emit AdaptiveLogged(adaptiveCount, bucket, triggerMetric, adjustment);
    }

    function viewAdaptive(uint256 id) external view returns (AdaptiveRule memory) {
        return adaptiveRules[id];
    }
}
