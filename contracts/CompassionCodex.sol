// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title CompassionCodex
/// @notice Covenant contract to safeguard communities through systemic anchoring of compassion practices
contract CompassionCodex {
    address public overseer;
    uint256 public compassionCount;

    struct CompassionEntry {
        uint256 id;
        string actor;
        string context;
        string method;
        uint256 timestamp;
    }

    mapping(uint256 => CompassionEntry) public compassions;

    event CompassionLogged(uint256 indexed id, string actor, string context);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logCompassion(
        string calldata actor,
        string calldata context,
        string calldata method
    ) external onlyOverseer {
        compassionCount++;
        compassions[compassionCount] = CompassionEntry({
            id: compassionCount,
            actor: actor,
            context: context,
            method: method,
            timestamp: block.timestamp
        });
        emit CompassionLogged(compassionCount, actor, context);
    }

    function viewCompassion(uint256 id) external view returns (CompassionEntry memory) {
        return compassions[id];
    }
}
