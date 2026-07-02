// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract HumanDevelopmentScroll {
    address public overseer;
    uint256 public scrollCount;

    struct Scroll {
        uint256 id;
        string focus;   // Education, Health, Skills
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => Scroll) public scrolls;
    event ScrollDeclared(uint256 indexed id, string focus, string description);

    constructor(address _overseer) {
        overseer = _overseer;
    }

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    function declareScroll(string calldata focus, string calldata description) external onlyOverseer {
        scrollCount++;
        scrolls[scrollCount] = Scroll(scrollCount, focus, description, block.timestamp);
        emit ScrollDeclared(scrollCount, focus, description);
    }
}
