// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title DignityCodex
/// @notice Covenant contract to safeguard communities through systemic anchoring of dignity principles
contract DignityCodex {
    address public overseer;
    uint256 public dignityCount;

    struct DignityEntry {
        uint256 id;
        string actor;
        string context;
        string principle;
        uint256 timestamp;
    }

    mapping(uint256 => DignityEntry) public dignities;

    event DignityLogged(uint256 indexed id, string actor, string context);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logDignity(
        string calldata actor,
        string calldata context,
        string calldata principle
    ) external onlyOverseer {
        dignityCount++;
        dignities[dignityCount] = DignityEntry({
            id: dignityCount,
            actor: actor,
            context: context,
            principle: principle,
            timestamp: block.timestamp
        });
        emit DignityLogged(dignityCount, actor, context);
    }

    function viewDignity(uint256 id) external view returns (DignityEntry memory) {
        return dignities[id];
    }
}
