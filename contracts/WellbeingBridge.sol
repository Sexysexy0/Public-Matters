// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title WellbeingBridge
/// @notice Covenant contract to safeguard communities through systemic anchoring of holistic wellbeing safeguards
contract WellbeingBridge {
    address public overseer;
    uint256 public wellbeingCount;

    struct WellbeingEntry {
        uint256 id;
        string actor;
        string context;
        string principle;
        uint256 timestamp;
    }

    mapping(uint256 => WellbeingEntry) public wellbeings;

    event WellbeingLogged(uint256 indexed id, string actor, string context);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logWellbeing(
        string calldata actor,
        string calldata context,
        string calldata principle
    ) external onlyOverseer {
        wellbeingCount++;
        wellbeings[wellbeingCount] = WellbeingEntry({
            id: wellbeingCount,
            actor: actor,
            context: context,
            principle: principle,
            timestamp: block.timestamp
        });
        emit WellbeingLogged(wellbeingCount, actor, context);
    }

    function viewWellbeing(uint256 id) external view returns (WellbeingEntry memory) {
        return wellbeings[id];
    }
}
