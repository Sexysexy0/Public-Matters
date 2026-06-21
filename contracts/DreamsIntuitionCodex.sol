// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title DreamsIntuitionCodex
/// @notice Codex covenant to encode subconscious intuition and mathematical dreams
contract DreamsIntuitionCodex {
    address public overseer;
    uint256 public intuitionCount;

    struct IntuitionRecord {
        uint256 id;
        string source;      // dream, subconscious, intuition
        string safeguard;   // dignity clause, equity clause
        string notes;       // contextual application
        uint256 timestamp;
    }

    mapping(uint256 => IntuitionRecord) public records;

    event IntuitionLogged(uint256 indexed id, string source, string safeguard);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs intuition record
    function logIntuition(string calldata source, string calldata safeguard, string calldata notes) external onlyOverseer {
        intuitionCount++;
        records[intuitionCount] = IntuitionRecord({
            id: intuitionCount,
            source: source,
            safeguard: safeguard,
            notes: notes,
            timestamp: block.timestamp
        });
        emit IntuitionLogged(intuitionCount, source, safeguard);
    }

    /// @notice Citizens can view intuition records
    function viewIntuition(uint256 id) external view returns (IntuitionRecord memory) {
        return records[id];
