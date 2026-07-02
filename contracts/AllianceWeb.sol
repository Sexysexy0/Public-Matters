// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract AllianceWeb {
    address public overseer;
    uint256 public allianceCount;

    struct Alliance {
        uint256 id;
        string partner;
        string purpose;
        uint256 timestamp;
    }

    mapping(uint256 => Alliance) public alliances;
    event AllianceForged(uint256 indexed id, string partner, string purpose);

    constructor(address _overseer) {
        overseer = _overseer;
    }

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    function forgeAlliance(string calldata partner, string calldata purpose) external onlyOverseer {
        allianceCount++;
        alliances[allianceCount] = Alliance(allianceCount, partner, purpose, block.timestamp);
        emit AllianceForged(allianceCount, partner, purpose);
    }
}
