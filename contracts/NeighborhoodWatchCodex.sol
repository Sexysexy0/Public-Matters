// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title NeighborhoodWatchCodex
/// @notice Covenant contract to safeguard communities through grassroots vigilance and community watch
contract NeighborhoodWatchCodex {
    address public overseer;
    uint256 public watchCount;

    struct WatchEntry {
        uint256 id;
        string member;
        string shift;
        string area;
        uint256 timestamp;
    }

    mapping(uint256 => WatchEntry) public watchEntries;

    event WatchLogged(uint256 indexed id, string member, string shift);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logWatch(
        string calldata member,
        string calldata shift,
        string calldata area
    ) external onlyOverseer {
        watchCount++;
        watchEntries[watchCount] = WatchEntry({
            id: watchCount,
            member: member,
            shift: shift,
            area: area,
            timestamp: block.timestamp
        });
        emit WatchLogged(watchCount, member, shift);
    }

    function viewWatch(uint256 id) external view returns (WatchEntry memory) {
        return watchEntries[id];
    }
}
