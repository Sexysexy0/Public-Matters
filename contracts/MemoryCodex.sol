// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title MemoryCodex
/// @notice Covenant contract to safeguard communities through systemic anchoring of collective memory
contract MemoryCodex {
    address public overseer;
    uint256 public memoryCount;

    struct MemoryEntry {
        uint256 id;
        string actor;
        string context;
        string principle;
        uint256 timestamp;
    }

    mapping(uint256 => MemoryEntry) public memories;

    event MemoryLogged(uint256 indexed id, string actor, string context);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logMemory(
        string calldata actor,
        string calldata context,
        string calldata principle
    ) external onlyOverseer {
        memoryCount++;
        memories[memoryCount] = MemoryEntry({
            id: memoryCount,
            actor: actor,
            context: context,
            principle: principle,
            timestamp: block.timestamp
        });
        emit MemoryLogged(memoryCount, actor, context);
    }

    function viewMemory(uint256 id) external view returns (MemoryEntry memory) {
        return memories[id];
    }
}
