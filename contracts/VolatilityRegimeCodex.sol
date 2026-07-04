// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title VolatilityRegimeCodex
/// @notice Encodes volatility regime classification rules.
/// @dev Anchors regime thresholds, posture rules, and environment awareness.

contract VolatilityRegimeCodex {
    address public overseer;
    uint256 public regimeCount;

    struct Regime {
        uint256 id;
        string principle;   // Low, Medium, High, Extreme volatility
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => Regime> public regimes;
    event RegimeDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) {
        overseer = _overseer;
    }

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    function declareRegime(string calldata principle, string calldata description) external onlyOverseer {
        regimeCount++;
        regimes[regimeCount] = Regime(regimeCount, principle, description, block.timestamp);
        emit RegimeDeclared(regimeCount, principle, description);
    }
}
