// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CrisisSolidarityScroll {
    address public overseer;
    uint256 public measureCount;

    struct Measure {
        uint256 id;
        string action;   // Collective Aid, Shared Burden
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => Measure) public measures;
    event MeasureDeclared(uint256 indexed id, string action, string description);

    constructor(address _overseer) {
        overseer = _overseer;
    }

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    function declareMeasure(string calldata action, string calldata description) external onlyOverseer {
        measureCount++;
        measures[measureCount] = Measure(measureCount, action, description, block.timestamp);
        emit MeasureDeclared(measureCount, action, description);
    }
}
