// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title HealthSupportCodex
/// @notice Covenant contract to safeguard schools through systemic medical support and health services
contract HealthSupportCodex {
    address public overseer;
    uint256 public healthCount;

    struct HealthEntry {
        uint256 id;
        string service;
        string provider;
        string location;
        uint256 timestamp;
    }

    mapping(uint256 => HealthEntry) public healthEntries;

    event HealthLogged(uint256 indexed id, string service, string provider);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logHealth(
        string calldata service,
        string calldata provider,
        string calldata location
    ) external onlyOverseer {
        healthCount++;
        healthEntries[healthCount] = HealthEntry({
            id: healthCount,
            service: service,
            provider: provider,
            location: location,
            timestamp: block.timestamp
        });
        emit HealthLogged(healthCount, service, provider);
    }

    function viewHealth(uint256 id) external view returns (HealthEntry memory) {
        return healthEntries[id];
    }
}
