// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract PublicBenefitLedger {
    address public overseer;
    uint256 public recordCount;

    struct Record {
        uint256 id;
        string benefit;   // Healthcare, Education, Energy Relief
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => Record) public records;
    event BenefitRecorded(uint256 indexed id, string benefit, string description);

    constructor(address _overseer) {
        overseer = _overseer;
    }

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    function recordBenefit(string calldata benefit, string calldata description) external onlyOverseer {
        recordCount++;
        records[recordCount] = Record(recordCount, benefit, description, block.timestamp);
        emit BenefitRecorded(recordCount, benefit, description);
    }
}
