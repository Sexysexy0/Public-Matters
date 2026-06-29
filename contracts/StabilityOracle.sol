// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title StabilityOracle
/// @notice Covenant contract to safeguard portfolios through systemic anchoring of stability safeguards
contract StabilityOracle {
    address public overseer;
    uint256 public stabilityCount;

    struct StabilityRule {
        uint256 id;
        string metric; // Volatility Cap, Liquidity Floor, Allocation Balance, Drawdown Buffer
        uint256 value; // numeric safeguard threshold
        uint256 timestamp;
    }

    mapping(uint256 => StabilityRule) public stabilities;

    event StabilityLogged(uint256 indexed id, string metric, uint256 value);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logStability(
        string calldata metric,
        uint256 value
    ) external onlyOverseer {
        stabilityCount++;
        stabilities[stabilityCount] = StabilityRule({
            id: stabilityCount,
            metric: metric,
            value: value,
            timestamp: block.timestamp
        });
        emit StabilityLogged(stabilityCount, metric, value);
    }

    function viewStability(uint256 id) external view returns (StabilityRule memory) {
        return stabilities[id];
    }
}
