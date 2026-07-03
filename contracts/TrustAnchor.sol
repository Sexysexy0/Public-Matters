// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TrustAnchor {
    address public overseer;
    uint256 public anchorCount;

    struct Anchor {
        uint256 id;
        string principle;
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => Anchor) public anchors;
    event AnchorDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) {
        overseer = _overseer;
    }

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    function declareAnchor(string calldata principle, string calldata description) external onlyOverseer {
        anchorCount++;
        anchors[anchorCount] = Anchor(anchorCount, principle, description, block.timestamp);
        emit AnchorDeclared(anchorCount, principle, description);
    }
}
