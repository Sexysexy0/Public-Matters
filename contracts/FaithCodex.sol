// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title FaithCodex
/// @notice Covenant contract to safeguard communities through systemic anchoring of faith practices
contract FaithCodex {
    address public overseer;
    uint256 public faithCount;

    struct FaithEntry {
        uint256 id;
        string actor;
        string context;
        string principle;
        uint256 timestamp;
    }

    mapping(uint256 => FaithEntry) public faiths;

    event FaithLogged(uint256 indexed id, string actor, string context);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logFaith(
        string calldata actor,
        string calldata context,
        string calldata principle
    ) external onlyOverseer {
        faithCount++;
        faiths[faithCount] = FaithEntry({
            id: faithCount,
            actor: actor,
            context: context,
            principle: principle,
            timestamp: block.timestamp
        });
        emit FaithLogged(faithCount, actor, context);
    }

    function viewFaith(uint256 id) external view returns (FaithEntry memory) {
        return faiths[id];
    }
}
