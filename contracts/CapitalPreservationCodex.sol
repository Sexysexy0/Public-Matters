// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title CapitalPreservationCodex
/// @notice Covenant contract to safeguard portfolios through systemic anchoring of capital preservation safeguards
contract CapitalPreservationCodex {
    address public overseer;
    uint256 public preservationCount;

    struct PreservationRule {
        uint256 id;
        string principle; // Stop-Loss, Safety Buffer, Stablecoin Allocation, Risk Cap
        uint256 threshold; // numeric safeguard value
        uint256 timestamp;
    }

    mapping(uint256 => PreservationRule) public preservations;

    event PreservationLogged(uint256 indexed id, string principle, uint256 threshold);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logPreservation(
        string calldata principle,
        uint256 threshold
    ) external onlyOverseer {
        preservationCount++;
        preservations[preservationCount] = PreservationRule({
            id: preservationCount,
            principle: principle,
            threshold: threshold,
            timestamp: block.timestamp
        });
        emit PreservationLogged(preservationCount, principle, threshold);
    }

    function viewPreservation(uint256 id) external view returns (PreservationRule memory) {
        return preservations[id];
    }
}
