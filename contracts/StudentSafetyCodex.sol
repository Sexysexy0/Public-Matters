// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title StudentSafetyCodex
/// @notice Covenant contract to safeguard students through holistic safety and wellness protocols
contract StudentSafetyCodex {
    address public overseer;
    uint256 public safetyCount;

    struct SafetyEntry {
        uint256 id;
        string risk;
        string protocol;
        string location;
        uint256 timestamp;
    }

    mapping(uint256 => SafetyEntry) public safetyEntries;

    event SafetyProtocolLogged(uint256 indexed id, string risk, string protocol);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logSafety(
        string calldata risk,
        string calldata protocol,
        string calldata location
    ) external onlyOverseer {
        safetyCount++;
        safetyEntries[safetyCount] = SafetyEntry({
            id: safetyCount,
            risk: risk,
            protocol: protocol,
            location: location,
            timestamp: block.timestamp
        });
        emit SafetyProtocolLogged(safetyCount, risk, protocol);
    }

    function viewSafety(uint256 id) external view returns (SafetyEntry memory) {
        return safetyEntries[id];
    }
}
