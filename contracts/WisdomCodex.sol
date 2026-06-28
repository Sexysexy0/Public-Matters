// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title WisdomCodex
/// @notice Covenant contract to safeguard communities through systemic anchoring of wisdom principles
contract WisdomCodex {
    address public overseer;
    uint256 public wisdomCount;

    struct WisdomEntry {
        uint256 id;
        string actor;
        string context;
        string principle;
        uint256 timestamp;
    }

    mapping(uint256 => WisdomEntry) public wisdoms;

    event WisdomLogged(uint256 indexed id, string actor, string context);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logWisdom(
        string calldata actor,
        string calldata context,
        string calldata principle
    ) external onlyOverseer {
        wisdomCount++;
        wisdoms[wisdomCount] = WisdomEntry({
            id: wisdomCount,
            actor: actor,
            context: context,
            principle: principle,
            timestamp: block.timestamp
        });
        emit WisdomLogged(wisdomCount, actor, context);
    }

    function viewWisdom(uint256 id) external view returns (WisdomEntry memory) {
        return wisdoms[id];
    }
}
