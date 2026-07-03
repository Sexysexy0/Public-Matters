// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title DrawdownShieldCodex
/// @notice Covenant contract to safeguard portfolios through systemic anchoring of drawdown shield safeguards
contract DrawdownShieldCodex {
    address public overseer;
    uint256 public shieldCount;

    struct ShieldRule {
        uint256 id;
        string asset; // e.g., BTC, ETH
        uint256 maxDrawdown; // allowable drawdown %
        string action; // Trim, Exit, Hedge
        uint256 timestamp;
    }

    mapping(uint256 => ShieldRule) public shields;

    event ShieldLogged(uint256 indexed id, string asset, uint256 maxDrawdown, string action);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logShield(
        string calldata asset,
        uint256 maxDrawdown,
        string calldata action
    ) external onlyOverseer {
        shieldCount++;
        shields[shieldCount] = ShieldRule({
            id: shieldCount,
            asset: asset,
            maxDrawdown: maxDrawdown,
            action: action,
            timestamp: block.timestamp
        });
        emit ShieldLogged(shieldCount, asset, maxDrawdown, action);
    }

    function viewShield(uint256 id) external view returns (ShieldRule memory) {
        return shields[id];
    }
}
