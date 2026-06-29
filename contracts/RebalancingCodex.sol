// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title RebalancingCodex
/// @notice Covenant contract to safeguard portfolios through systemic anchoring of rebalancing safeguards
contract RebalancingCodex {
    address public overseer;
    uint256 public rebalanceCount;

    struct RebalanceRule {
        uint256 id;
        string bucket; // Core, Satellite, Safety
        string trigger; // e.g., Monthly, Threshold Breach
        string action; // Trim, Add, Exit
        uint256 timestamp;
    }

    mapping(uint256 => RebalanceRule) public rules;

    event RebalanceLogged(uint256 indexed id, string bucket, string trigger, string action);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logRebalance(
        string calldata bucket,
        string calldata trigger,
        string calldata action
    ) external onlyOverseer {
        rebalanceCount++;
        rules[rebalanceCount] = RebalanceRule({
            id: rebalanceCount,
            bucket: bucket,
            trigger: trigger,
            action: action,
            timestamp: block.timestamp
        });
        emit RebalanceLogged(rebalanceCount, bucket, trigger, action);
    }

    function viewRebalance(uint256 id) external view returns (RebalanceRule memory) {
        return rules[id];
    }
}
