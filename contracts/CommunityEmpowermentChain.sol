// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CommunityEmpowermentChain {
    address public overseer;
    uint256 public initiativeCount;

    struct Initiative {
        uint256 id;
        string program;   // Grassroots, Local Development, Empowerment
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => Initiative) public initiatives;
    event InitiativeDeclared(uint256 indexed id, string program, string description);

    constructor(address _overseer) {
        overseer = _overseer;
    }

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    function declareInitiative(string calldata program, string calldata description) external onlyOverseer {
        initiativeCount++;
        initiatives[initiativeCount] = Initiative(initiativeCount, program, description, block.timestamp);
        emit InitiativeDeclared(initiativeCount, program, description);
    }
}
