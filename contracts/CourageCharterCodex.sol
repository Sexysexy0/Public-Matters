// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title CourageCharterCodex
/// @notice Covenant contract to safeguard communities through anchoring courage against fear
contract CourageCharterCodex {
    address public overseer;
    uint256 public courageCount;

    struct CourageEntry {
        uint256 id;
        string actor;
        string fear;
        string act;
        uint256 timestamp;
    }

    mapping(uint256 => CourageEntry) public courageActs;

    event CourageLogged(uint256 indexed id, string actor, string act);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logCourage(
        string calldata actor,
        string calldata fear,
        string calldata act
    ) external onlyOverseer {
        courageCount++;
        courageActs[courageCount] = CourageEntry({
            id: courageCount,
            actor: actor,
            fear: fear,
            act: act,
            timestamp: block.timestamp
        });
        emit CourageLogged(courageCount, actor, act);
    }

    function viewCourage(uint256 id) external view returns (CourageEntry memory) {
        return courageActs[id];
    }
}
