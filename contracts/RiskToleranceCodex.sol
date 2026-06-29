// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title RiskToleranceCodex
/// @notice Covenant contract to safeguard portfolios through systemic anchoring of risk tolerance safeguards
contract RiskToleranceCodex {
    address public overseer;
    uint256 public toleranceCount;

    struct ToleranceRule {
        uint256 id;
        string profile; // Conservative, Balanced, Aggressive
        uint256 maxDrawdown; // allowable drawdown %
        uint256 volatilityCap; // allowable volatility %
        uint256 timestamp;
    }

    mapping(uint256 => ToleranceRule) public tolerances;

    event ToleranceLogged(uint256 indexed id, string profile, uint256 maxDrawdown, uint256 volatilityCap);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logTolerance(
        string calldata profile,
        uint256 maxDrawdown,
        uint256 volatilityCap
    ) external onlyOverseer {
        toleranceCount++;
        tolerances[toleranceCount] = ToleranceRule({
            id: toleranceCount,
            profile: profile,
            maxDrawdown: maxDrawdown,
            volatilityCap: volatilityCap,
            timestamp: block.timestamp
        });
        emit ToleranceLogged(toleranceCount, profile, maxDrawdown, volatilityCap);
    }

    function viewTolerance(uint256 id) external view returns (ToleranceRule memory) {
        return tolerances[id];
    }
}
