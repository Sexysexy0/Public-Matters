// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title ProgressChronicle
/// @notice Covenant encoding daily progress and accountability
contract ProgressChronicle {
    address public overseer;
    uint256 public entryCount;

    struct Entry {
        uint256 id;
        string milestone;   // Improvement, Accountability, Achievement
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => Entry) public entries;

    event EntryDeclared(uint256 indexed id, string milestone, string description);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function declareEntry(string calldata milestone, string calldata description) external onlyOverseer {
        entryCount++;
        entries[entryCount] = Entry(entryCount, milestone, description, block.timestamp);
        emit EntryDeclared(entryCount, milestone, description);
    }

    function viewEntry(uint256 id) external view returns (Entry memory) {
        return entries[id];
    }
}
