// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract GlobalUnityChain {
    address public overseer;
    uint256 public linkCount;

    struct Link {
        uint256 id;
        string nation;
        string initiative;
        uint256 timestamp;
    }

    mapping(uint256 => Link) public links;
    event LinkForged(uint256 indexed id, string nation, string initiative);

    constructor(address _overseer) {
        overseer = _overseer;
    }

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    function forgeLink(string calldata nation, string calldata initiative) external onlyOverseer {
        linkCount++;
        links[linkCount] = Link(linkCount, nation, initiative, block.timestamp);
        emit LinkForged(linkCount, nation, initiative);
    }
}
