// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title CourageCodex
/// @notice Covenant contract to safeguard communities through systemic anchoring of courage against fear
contract CourageCodex {
    address public overseer;
    uint256 public courageCount;

    struct CourageEntry {
        uint256 id;
        string actor;
        string context;
        string principle;
        uint256 timestamp;
    }

    mapping(uint256 => CourageEntry) public courages;

    event CourageLogged(uint256 indexed id, string actor, string context);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logCourage(
        string calldata actor,
        string calldata context,
        string calldata principle
    ) external onlyOverseer {
        courageCount++;
        courages[courageCount] = CourageEntry({
            id: courageCount,
            actor: actor,
            context: context,
            principle: principle,
            timestamp: block.timestamp
        });
        emit CourageLogged(courageCount, actor, context);
    }

    function viewCourage(uint256 id) external view returns (CourageEntry memory) {
        return courages[id];
    }
}
