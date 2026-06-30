// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title ForgivenessCodex
/// @notice Covenant contract to safeguard systemic reconciliation, principled forgiveness, and dignified healing
contract ForgivenessCodex {
    address public overseer;
    uint256 public forgivenessCount;

    struct ForgivenessRule {
        uint256 id;
        string principle; // Reconciliation, Healing, Mercy, Renewal
        string description; // encoded forgiveness safeguard
        uint256 timestamp;
    }

    mapping(uint256 => ForgivenessRule) public forgivenesses;

    event ForgivenessLogged(uint256 indexed id, string principle, string description);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logForgiveness(
        string calldata principle,
        string calldata description
    ) external onlyOverseer {
        forgivenessCount++;
        forgivenesses[forgivenessCount] = ForgivenessRule({
            id: forgivenessCount,
            principle: principle,
            description: description,
            timestamp: block.timestamp
        });
        emit ForgivenessLogged(forgivenessCount, principle, description);
    }

    function viewForgiveness(uint256 id) external view returns (ForgivenessRule memory) {
        return forgivenesses[id];
    }
}
