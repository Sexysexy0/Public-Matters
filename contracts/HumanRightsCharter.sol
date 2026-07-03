// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract HumanRightsCharter {
    address public overseer;
    uint256 public charterCount;

    struct Charter {
        uint256 id;
        string right;   // Freedom, Equality, Dignity
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => Charter) public charters;
    event RightDeclared(uint256 indexed id, string right, string description);

    constructor(address _overseer) {
        overseer = _overseer;
    }

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    function declareRight(string calldata right, string calldata description) external onlyOverseer {
        charterCount++;
        charters[charterCount] = Charter(charterCount, right, description, block.timestamp);
        emit RightDeclared(charterCount, right, description);
    }
}
