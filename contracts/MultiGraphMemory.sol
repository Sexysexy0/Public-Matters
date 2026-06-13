// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title MultiGraphMemory
/// @notice Covenant for relational + tool memory safeguard
contract MultiGraphMemory {
    address public oversightCommittee;
    uint256 public memoryCount;

    struct MemoryNode {
        uint256 id;
        string modality;   // relational, tool, contextual
        string content;    // stored info
        uint256 timestamp;
    }

    mapping(uint256 => MemoryNode) public memories;

    event MemoryStored(uint256 indexed id, string modality, string content);

    modifier onlyOversight() {
        require(msg.sender == oversightCommittee, "Not authorized");
        _;
    }

    constructor(address _oversightCommittee) {
        oversightCommittee = _oversightCommittee;
    }

    /// @notice Oversight stores relational or tool memory
    function storeMemory(string calldata modality, string calldata content) external onlyOversight {
        memoryCount++;
        memories[memoryCount] = MemoryNode({
            id: memoryCount,
            modality: modality,
            content: content,
            timestamp: block.timestamp
        });
        emit MemoryStored(memoryCount, modality, content);
    }

    /// @notice Citizens can view memory nodes
    function viewMemory(uint256 id) external view returns (MemoryNode memory) {
        return memories[id];
    }
}
