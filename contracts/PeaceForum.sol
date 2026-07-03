// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract PeaceForum {
    address public overseer;
    uint256 public forumCount;

    struct Forum {
        uint256 id;
        string topic;
        string resolution;
        uint256 timestamp;
    }

    mapping(uint256 => Forum) public forums;
    event ForumOpened(uint256 indexed id, string topic, string resolution);

    constructor(address _overseer) {
        overseer = _overseer;
    }

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    function openForum(string calldata topic, string calldata resolution) external onlyOverseer {
        forumCount++;
        forums[forumCount] = Forum(forumCount, topic, resolution, block.timestamp);
        emit ForumOpened(forumCount, topic, resolution);
    }
}
