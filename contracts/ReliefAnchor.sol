// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ReliefAnchor {
    address public overseer;
    uint256 public anchorCount;

    struct Anchor {
        uint256 id;
        string measure;   // Subsidy, Direct Aid, Community Support
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => Anchor) public anchors;
    event AnchorDeclared(uint256 indexed id, string measure, string description);

    constructor(address _overseer) {
        overseer = _overseer;
    }

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    function declareAnchor(string calldata measure, string calldata description) external onlyOverseer {
        anchorCount++;
        anchors[anchorCount] = Anchor(anchorCount, measure, description, block.timestamp);
        emit AnchorDeclared(anchorCount, measure, description);
    }
}
