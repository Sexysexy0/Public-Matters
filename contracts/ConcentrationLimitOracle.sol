// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title ConcentrationLimitOracle
/// @notice Covenant contract to safeguard portfolios through systemic anchoring of concentration limit safeguards
contract ConcentrationLimitOracle {
    address public overseer;
    uint256 public limitCount;

    struct ConcentrationRule {
        uint256 id;
        string asset; // e.g., BTC, ETH
        uint256 maxPercentage; // allocation cap
        string bucket; // Core, Satellite, Safety
        uint256 timestamp;
    }

    mapping(uint256 => ConcentrationRule) public limits;

    event LimitLogged(uint256 indexed id, string asset, uint256 maxPercentage, string bucket);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logLimit(
        string calldata asset,
        uint256 maxPercentage,
        string calldata bucket
    ) external onlyOverseer {
        limitCount++;
        limits[limitCount] = ConcentrationRule({
            id: limitCount,
            asset: asset,
            maxPercentage: maxPercentage,
            bucket: bucket,
            timestamp: block.timestamp
        });
        emit LimitLogged(limitCount, asset, maxPercentage, bucket);
    }

    function viewLimit(uint256 id) external view returns (ConcentrationRule memory) {
        return limits[id];
    }
}
