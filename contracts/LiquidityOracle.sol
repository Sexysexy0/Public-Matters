// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title LiquidityOracle
/// @notice Covenant contract to safeguard portfolios through systemic anchoring of liquidity safeguards
contract LiquidityOracle {
    address public overseer;
    uint256 public liquidityCount;

    struct LiquidityRule {
        uint256 id;
        string asset; // e.g., BTC, ETH
        uint256 minLiquidity; // minimum required liquidity (USD volume/day)
        uint256 exitWindow; // max time allowed to exit position (hours/days)
        uint256 timestamp;
    }

    mapping(uint256 => LiquidityRule) public liquidities;

    event LiquidityLogged(uint256 indexed id, string asset, uint256 minLiquidity, uint256 exitWindow);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logLiquidity(
        string calldata asset,
        uint256 minLiquidity,
        uint256 exitWindow
    ) external onlyOverseer {
        liquidityCount++;
        liquidities[liquidityCount] = LiquidityRule({
            id: liquidityCount,
            asset: asset,
            minLiquidity: minLiquidity,
            exitWindow: exitWindow,
            timestamp: block.timestamp
        });
        emit LiquidityLogged(liquidityCount, asset, minLiquidity, exitWindow);
    }

    function viewLiquidity(uint256 id) external view returns (LiquidityRule memory) {
        return liquidities[id];
    }
}
