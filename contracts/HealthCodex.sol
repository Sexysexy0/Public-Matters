// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title HealthCodex
/// @notice Covenant contract to symbolically safeguard medical cannabis, therapeutic recognition, and health equity
contract HealthCodex {
    address public overseer;
    uint256 public healthCount;

    struct HealthRule {
        uint256 id;
        string principle; // Medical Cannabis, Therapeutic Safeguards, Health Equity, Human Dignity
        string description; // encoded health safeguard
        uint256 timestamp;
    }

    mapping(uint256 => HealthRule) public healths;

    event HealthLogged(uint256 indexed id, string principle, string description);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logHealth(
        string calldata principle,
        string calldata description
    ) external onlyOverseer {
        healthCount++;
        healths[healthCount] = HealthRule({
            id: healthCount,
            principle: principle,
            description: description,
            timestamp: block.timestamp
        });
        emit HealthLogged(healthCount, principle, description);
    }

    function viewHealth(uint256 id) external view returns (HealthRule memory) {
        return healths[id];
    }
}
