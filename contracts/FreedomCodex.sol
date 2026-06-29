// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title FreedomCodex
/// @notice Covenant contract to safeguard communities through systemic anchoring of freedom safeguards
contract FreedomCodex {
    address public overseer;
    uint256 public freedomCount;

    struct FreedomEntry {
        uint256 id;
        string actor;
        string context;
        string principle;
        uint256 timestamp;
    }

    mapping(uint256 => FreedomEntry) public freedoms;

    event FreedomLogged(uint256 indexed id, string actor, string context);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logFreedom(
        string calldata actor,
        string calldata context,
        string calldata principle
    ) external onlyOverseer {
        freedomCount++;
        freedoms[freedomCount] = FreedomEntry({
            id: freedomCount,
            actor: actor,
            context: context,
            principle: principle,
            timestamp: block.timestamp
        });
        emit FreedomLogged(freedomCount, actor, context);
    }

    function viewFreedom(uint256 id) external view returns (FreedomEntry memory) {
        return freedoms[id];
    }
}
