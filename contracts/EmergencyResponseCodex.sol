// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title EmergencyResponseCodex
/// @notice Covenant contract to encode systemic emergency drills and rapid response protocols
contract EmergencyResponseCodex {
    address public overseer;
    uint256 public responseCount;

    struct ResponseEntry {
        uint256 id;
        string scenario;
        string protocol;
        string location;
        uint256 timestamp;
    }

    mapping(uint256 => ResponseEntry) public responses;

    event ResponseLogged(uint256 indexed id, string scenario, string protocol);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logResponse(
        string calldata scenario,
        string calldata protocol,
        string calldata location
    ) external onlyOverseer {
        responseCount++;
        responses[responseCount] = ResponseEntry({
            id: responseCount,
            scenario: scenario,
            protocol: protocol,
            location: location,
            timestamp: block.timestamp
        });
        emit ResponseLogged(responseCount, scenario, protocol);
    }

    function viewResponse(uint256 id) external view returns (ResponseEntry memory) {
        return responses[id];
    }
}
