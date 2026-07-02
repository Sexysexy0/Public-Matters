// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CommunityImpactScroll {
    address public overseer;
    uint256 public impactCount;

    struct Impact {
        uint256 id;
        string sector;   // Energy, Food, Transport
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => Impact) public impacts;
    event ImpactDeclared(uint256 indexed id, string sector, string description);

    constructor(address _overseer) {
        overseer = _overseer;
    }

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    function declareImpact(string calldata sector, string calldata description) external onlyOverseer {
        impactCount++;
        impacts[impactCount] = Impact(impactCount, sector, description, block.timestamp);
        emit ImpactDeclared(impactCount, sector, description);
    }
}
