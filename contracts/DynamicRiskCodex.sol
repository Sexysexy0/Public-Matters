// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title DynamicRiskCodex
/// @notice Covenant contract to safeguard portfolios through systemic anchoring of dynamic risk safeguards
contract DynamicRiskCodex {
    address public overseer;
    uint256 public riskCount;

    struct RiskRule {
        uint256 id;
        string metric; // Volatility Index, Liquidity Stress, Market Trend, Drawdown
        uint256 threshold; // safeguard value
        string response; // Hedge, Rebalance, Exit, Buffer
        uint256 timestamp;
    }

    mapping(uint256 => RiskRule) public risks;

    event RiskLogged(uint256 indexed id, string metric, uint256 threshold, string response);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logRisk(
        string calldata metric,
        uint256 threshold,
        string calldata response
    ) external onlyOverseer {
        riskCount++;
        risks[riskCount] = RiskRule({
            id: riskCount,
            metric: metric,
            threshold: threshold,
            response: response,
            timestamp: block.timestamp
        });
        emit RiskLogged(riskCount, metric, threshold, response);
    }

    function viewRisk(uint256 id) external view returns (RiskRule memory) {
        return risks[id];
    }
}
