// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title SolidarityCodex
/// @notice Covenant contract to safeguard communities through anchoring solidarity and collective strength
contract SolidarityCodex {
    address public overseer;
    uint256 public solidarityCount;

    struct SolidarityEntry {
        uint256 id;
        string actor;
        string context;
        string method;
        uint256 timestamp;
    }

    mapping(uint256 => SolidarityEntry) public solidarities;

    event SolidarityLogged(uint256 indexed id, string actor, string context);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logSolidarity(
        string calldata actor,
        string calldata context,
        string calldata method
    ) external onlyOverseer {
        solidarityCount++;
        solidarities[solidarityCount] = SolidarityEntry({
            id: solidarityCount,
            actor: actor,
            context: context,
            method: method,
            timestamp: block.timestamp
        });
        emit SolidarityLogged(solidarityCount, actor, context);
    }

    function viewSolidarity(uint256 id) external view returns (SolidarityEntry memory) {
        return solidarities[id];
    }
}
