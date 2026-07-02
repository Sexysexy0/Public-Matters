// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CommunityReliefChain {
    address public overseer;
    uint256 public reliefCount;

    struct Relief {
        uint256 id;
        string measure;   // Subsidy, Aid, Support
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => Relief) public reliefs;
    event ReliefDeployed(uint256 indexed id, string measure, string description);

    constructor(address _overseer) {
        overseer = _overseer;
    }

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    function deployRelief(string calldata measure, string calldata description) external onlyOverseer {
        reliefCount++;
        reliefs[reliefCount] = Relief(reliefCount, measure, description, block.timestamp);
        emit ReliefDeployed(reliefCount, measure, description);
    }
}
