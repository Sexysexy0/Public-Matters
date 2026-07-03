// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title DiversificationOracle
/// @notice Covenant contract to safeguard portfolios through systemic anchoring of diversification safeguards
contract DiversificationOracle {
    address public overseer;
    uint256 public ruleCount;

    struct DiversificationRule {
        uint256 id;
        string bucket; // Core, Satellite, Safety
        uint256 maxAllocation; // percentage allocation cap
        string rebalanceFrequency; // e.g., Monthly, Quarterly
        uint256 timestamp;
    }

    mapping(uint256 => DiversificationRule) public rules;

    event RuleLogged(uint256 indexed id, string bucket, uint256 maxAllocation, string rebalanceFrequency);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logRule(
        string calldata bucket,
        uint256 maxAllocation,
        string calldata rebalanceFrequency
    ) external onlyOverseer {
        ruleCount++;
        rules[ruleCount] = DiversificationRule({
            id: ruleCount,
            bucket: bucket,
            maxAllocation: maxAllocation,
            rebalanceFrequency: rebalanceFrequency,
            timestamp: block.timestamp
        });
        emit RuleLogged(ruleCount, bucket, maxAllocation, rebalanceFrequency);
    }

    function viewRule(uint256 id) external view returns (DiversificationRule memory) {
        return rules[id];
    }
}
