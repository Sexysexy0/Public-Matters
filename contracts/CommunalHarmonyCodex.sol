// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title CommunalHarmonyCodex
/// @notice Covenant contract to safeguard communities through reconciliation and harmony
contract CommunalHarmonyCodex {
    address public overseer;
    uint256 public harmonyCount;

    struct HarmonyEntry {
        uint256 id;
        string actor;
        string method;
        string context;
        uint256 timestamp;
    }

    mapping(uint256 => HarmonyEntry) public harmonies;

    event HarmonyLogged(uint256 indexed id, string actor, string method);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logHarmony(
        string calldata actor,
        string calldata method,
        string calldata context
    ) external onlyOverseer {
        harmonyCount++;
        harmonies[harmonyCount] = HarmonyEntry({
            id: harmonyCount,
            actor: actor,
            method: method,
            context: context,
            timestamp: block.timestamp
        });
        emit HarmonyLogged(harmonyCount, actor, method);
    }

    function viewHarmony(uint256 id) external view returns (HarmonyEntry memory) {
        return harmonies[id];
    }
}
