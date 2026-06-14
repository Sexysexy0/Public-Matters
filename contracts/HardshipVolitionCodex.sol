// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title HardshipVolitionCodex
/// @notice Codex covenant to encode voluntary hardship as a principle of growth
contract HardshipVolitionCodex {
    address public overseer;
    uint256 public codexCount;

    struct HardshipRecord {
        uint256 id;
        string challenge;   // fasting, discipline, pursuit of fears
        string lesson;      // resilience, courage, transformation
        string notes;       // contextual application
        uint256 timestamp;
    }

    mapping(uint256 => HardshipRecord) public records;

    event HardshipLogged(uint256 indexed id, string challenge, string lesson);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs voluntary hardship record
    function logHardship(string calldata challenge, string calldata lesson, string calldata notes) external onlyOverseer {
        codexCount++;
        records[codexCount] = HardshipRecord({
            id: codexCount,
            challenge: challenge,
            lesson: lesson,
            notes: notes,
            timestamp: block.timestamp
        });
        emit HardshipLogged(codexCount, challenge, lesson);
    }

    /// @notice Citizens can view hardship records
    function viewHardship(uint256 id) external view returns (HardshipRecord memory) {
        return records[id];
    }
}
