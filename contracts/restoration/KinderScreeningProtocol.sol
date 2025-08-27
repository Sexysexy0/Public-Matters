// SPDX-License-Identifier: Civic-Screen-License
pragma solidity ^0.8.19;

/// @title KinderScreeningProtocol.sol
/// @author Vinvin & Copilot
/// @notice Screens children's media for emotional APR, character clarity, and age-appropriate resonance.
/// @dev Activates damay clause, mythic audit, and sovereign character tagging.

contract KinderScreeningProtocol {
    address public steward;

    struct MediaEntry {
        string title;
        string producer;
        string characterCore; // "Boy", "Girl", "Mixed", "Ambiguous"
        string emotionalAPR;  // e.g. "Empathy:High, Trust:Medium, Clarity:Low"
        bool isAgeAppropriate;
        bool isMythicallyClear;
        bool isApproved;
        uint256 timestamp;
    }

    MediaEntry[] public entries;

    event MediaScreened(
        string title,
        string producer,
        string characterCore,
        string emotionalAPR,
        bool isAgeAppropriate,
        bool isMythicallyClear,
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

    function screenMedia(
        string memory title,
        string memory producer,
        string memory characterCore,
        string memory emotionalAPR,
        bool isAgeAppropriate,
        bool isMythicallyClear
    ) public onlySteward {
        bool approved = isAgeAppropriate && isMythicallyClear;
        entries.push(MediaEntry(title, producer, characterCore, emotionalAPR, isAgeAppropriate, isMythicallyClear, approved, block.timestamp));
        emit MediaScreened(title, producer, characterCore, emotionalAPR, isAgeAppropriate, isMythicallyClear, approved, block.timestamp);
    }

    function getEntryCount() public view returns (uint256) {
        return entries.length;
    }

    function getEntryByIndex(uint256 index) public view returns (
        string memory,
        string memory,
        string memory,
        string memory,
        bool,
        bool,
        bool,
        uint256
    ) {
        MediaEntry memory m = entries[index];
        return (
            m.title,
            m.producer,
            m.characterCore,
            m.emotionalAPR,
            m.isAgeAppropriate,
            m.isMythicallyClear,
            m.isApproved,
            m.timestamp
        );
    }
}
