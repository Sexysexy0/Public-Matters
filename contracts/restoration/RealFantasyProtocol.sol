// SPDX-License-Identifier: Scrollchain-Fantasy-License
pragma solidity ^0.8.19;

/// @title RealFantasyProtocol.sol
/// @notice Screens and validates fantasy/sci-fi stories for civic depth and emotional resonance.
/// @dev Activates damay clause, mythic audit, and truth-in-fantasy tagging.

contract RealFantasyProtocol {
    address public steward;

    struct StoryEntry {
        string title;
        string genre; // "Fantasy", "Sci-Fi", "Mythic", etc.
        string emotionalAPR;
        bool hasCivicTruth;
        bool hasMythicClarity;
        bool isApproved;
        uint256 timestamp;
    }

    StoryEntry[] public entries;

    event StoryScreened(
        string title,
        string genre,
        string emotionalAPR,
        bool hasCivicTruth,
        bool hasMythicClarity,
        bool isApproved,
        uint256 timestamp
    );

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function screenStory(
        string memory title,
        string memory genre,
        string memory emotionalAPR,
        bool hasCivicTruth,
        bool hasMythicClarity
    ) public onlySteward {
        bool approved = hasCivicTruth && hasMythicClarity;
        entries.push(StoryEntry(title, genre, emotionalAPR, hasCivicTruth, hasMythicClarity, approved, block.timestamp));
        emit StoryScreened(title, genre, emotionalAPR, hasCivicTruth, hasMythicClarity, approved, block.timestamp);
    }

    function getEntryCount() public view returns (uint256) {
        return entries.length;
    }

    function getEntryByIndex(uint256 index) public view returns (
        string memory,
        string memory,
        string memory,
        bool,
        bool,
        bool,
        uint256
    ) {
        StoryEntry memory s = entries[index];
        return (
            s.title,
            s.genre,
            s.emotionalAPR,
            s.hasCivicTruth,
            s.hasMythicClarity,
            s.isApproved,
            s.timestamp
        );
    }
}
