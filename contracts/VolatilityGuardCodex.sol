// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title VolatilityGuardCodex
/// @notice Covenant contract to safeguard portfolios through systemic anchoring of volatility guard safeguards
contract VolatilityGuardCodex {
    address public overseer;
    uint256 public guardCount;

    struct VolatilityRule {
        uint256 id;
        string asset; // e.g., BTC, ETH
        uint256 volatilityCap; // allowable volatility %
        uint256 drawdownShield; // allowable drawdown %
        uint256 timestamp;
    }

    mapping(uint256 => VolatilityRule) public guards;

    event GuardLogged(uint256 indexed id, string asset, uint256 volatilityCap, uint256 drawdownShield);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logGuard(
        string calldata asset,
        uint256 volatilityCap,
        uint256 drawdownShield
    ) external onlyOverseer {
        guardCount++;
        guards[guardCount] = VolatilityRule({
            id: guardCount,
            asset: asset,
            volatilityCap: volatilityCap,
            drawdownShield: drawdownShield,
            timestamp: block.timestamp
        });
        emit GuardLogged(guardCount, asset, volatilityCap, drawdownShield);
    }

    function viewGuard(uint256 id) external view returns (VolatilityRule memory) {
        return guards[id];
    }
}
