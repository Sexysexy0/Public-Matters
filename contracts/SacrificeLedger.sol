// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title SacrificeLedger
/// @notice Covenant contract to safeguard communities through recording true sacrifices and offerings
contract SacrificeLedger {
    address public overseer;
    uint256 public sacrificeCount;

    struct SacrificeEntry {
        uint256 id;
        string actor;
        string typeOfSacrifice;
        string intention;
        uint256 timestamp;
    }

    mapping(uint256 => SacrificeEntry) public sacrifices;

    event SacrificeLogged(uint256 indexed id, string actor, string typeOfSacrifice);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logSacrifice(
        string calldata actor,
        string calldata typeOfSacrifice,
        string calldata intention
    ) external onlyOverseer {
        sacrificeCount++;
        sacrifices[sacrificeCount] = SacrificeEntry({
            id: sacrificeCount,
            actor: actor,
            typeOfSacrifice: typeOfSacrifice,
            intention: intention,
            timestamp: block.timestamp
        });
        emit SacrificeLogged(sacrificeCount, actor, typeOfSacrifice);
    }

    function viewSacrifice(uint256 id) external view returns (SacrificeEntry memory) {
        return sacrifices[id];
    }
}
