// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title ChildWellbeingCodex
/// @notice Covenant contract to safeguard communities through systemic anchoring of holistic child wellbeing safeguards
contract ChildWellbeingCodex {
    address public overseer;
    uint256 public wellbeingCount;

    struct WellbeingEntry {
        uint256 id;
        string child;
        string guardian;
        string dimension;
        uint256 timestamp;
    }

    mapping(uint256 => WellbeingEntry) public wellbeings;

    event WellbeingLogged(uint256 indexed id, string child, string guardian, string dimension);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logWellbeing(
        string calldata child,
        string calldata guardian,
        string calldata dimension
    ) external onlyOverseer {
        wellbeingCount++;
        wellbeings[wellbeingCount] = WellbeingEntry({
            id: wellbeingCount,
            child: child,
            guardian: guardian,
            dimension: dimension,
            timestamp: block.timestamp
        });
        emit WellbeingLogged(wellbeingCount, child, guardian, dimension);
    }

    function viewWellbeing(uint256 id) external view returns (WellbeingEntry memory) {
        return wellbeings[id];
    }
}
