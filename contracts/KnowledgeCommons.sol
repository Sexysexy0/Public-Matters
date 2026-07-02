// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title KnowledgeCommons
/// @notice Covenant to safeguard shared knowledge systems,
///         ensuring open access, collaboration, and collective learning.
contract KnowledgeCommons {
    address public overseer;
    uint256 public commonsCount;

    struct Commons {
        uint256 id;
        string principle;   // OpenAccess, Collaboration, CollectiveLearning
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => Commons) public commons;

    event CommonsDeclared(uint256 indexed id, string principle, string description);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function declareCommons(string calldata principle, string calldata description) external onlyOverseer {
        commonsCount++;
        commons[commonsCount] = Commons(commonsCount, principle, description, block.timestamp);
        emit CommonsDeclared(commonsCount, principle, description);
    }

    function viewCommons(uint256 id) external view returns (Commons memory) {
        return commons[id];
    }
}
