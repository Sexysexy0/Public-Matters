// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title CrisisLogisticsCodex
/// @notice Covenant contract to safeguard communities through logistics coordination during crisis
contract CrisisLogisticsCodex {
    address public overseer;
    uint256 public logisticsCount;

    struct LogisticsEntry {
        uint256 id;
        string resource;
        string provider;
        string destination;
        uint256 timestamp;
    }

    mapping(uint256 => LogisticsEntry) public logisticsEntries;

    event LogisticsLogged(uint256 indexed id, string resource, string provider);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logLogistics(
        string calldata resource,
        string calldata provider,
        string calldata destination
    ) external onlyOverseer {
        logisticsCount++;
        logisticsEntries[logisticsCount] = LogisticsEntry({
            id: logisticsCount,
            resource: resource,
            provider: provider,
            destination: destination,
            timestamp: block.timestamp
        });
        emit LogisticsLogged(logisticsCount, resource, provider);
    }

    function viewLogistics(uint256 id) external view returns (LogisticsEntry memory) {
        return logisticsEntries[id];
    }
}
