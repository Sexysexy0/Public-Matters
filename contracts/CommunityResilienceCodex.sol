// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CommunityResilienceCodex {
    address public overseer;
    uint256 public measureCount;

    struct Measure {
        uint256 id;
        string initiative;   // Grassroots Aid, Local Empowerment
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => Measure) public measures;
    event MeasureDeclared(uint256 indexed id, string initiative, string description);

    constructor(address _overseer) {
        overseer = _overseer;
    }

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    function declareMeasure(string calldata initiative, string calldata description) external onlyOverseer {
        measureCount++;
        measures[measureCount] = Measure(measureCount, initiative, description, block.timestamp);
        emit MeasureDeclared(measureCount, initiative, description);
    }
}
