// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title StewardshipCodex
/// @notice Covenant contract to safeguard communities through responsible stewardship of resources and governance
contract StewardshipCodex {
    address public overseer;
    uint256 public stewardshipCount;

    struct StewardshipEntry {
        uint256 id;
        string actor;
        string domain;
        string method;
        uint256 timestamp;
    }

    mapping(uint256 => StewardshipEntry) public stewardships;

    event StewardshipLogged(uint256 indexed id, string actor, string domain);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logStewardship(
        string calldata actor,
        string calldata domain,
        string calldata method
    ) external onlyOverseer {
        stewardshipCount++;
        stewardships[stewardshipCount] = StewardshipEntry({
            id: stewardshipCount,
            actor: actor,
            domain: domain,
            method: method,
            timestamp: block.timestamp
        });
        emit StewardshipLogged(stewardshipCount, actor, domain);
    }

    function viewStewardship(uint256 id) external view returns (StewardshipEntry memory) {
        return stewardships[id];
    }
}
