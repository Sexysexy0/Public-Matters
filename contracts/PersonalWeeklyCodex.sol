// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title PersonalWeeklyCodex
/// @notice Covenant for weekly cadence of personal storytelling
contract PersonalWeeklyCodex {
    address public oversightCommittee;
    uint256 public entryCount;

    struct PersonalEntry {
        uint256 id;
        string title;
        string content;
        uint256 weekNumber;
        bool active;
        uint256 timestamp;
    }

    mapping(uint256 => PersonalEntry) public entries;

    event EntryPublished(uint256 indexed id, string title, uint256 weekNumber, bool active);

    modifier onlyOversight() {
        require(msg.sender == oversightCommittee, "Not authorized");
        _;
    }

    constructor(address _oversightCommittee) {
        oversightCommittee = _oversightCommittee;
    }

    /// @notice Oversight publishes one personal entry per week
    function publishEntry(string calldata title, string calldata content, uint256 weekNumber) external onlyOversight {
        entryCount++;
        entries[entryCount] = PersonalEntry({
            id: entryCount,
            title: title,
            content: content,
            weekNumber: weekNumber,
            active: true,
            timestamp: block.timestamp
        });
        emit EntryPublished(entryCount, title, weekNumber, true);
    }

    /// @notice Oversight deactivates a personal entry
    function deactivateEntry(uint256 id) external onlyOversight {
        entries[id].active = false;
        emit EntryPublished(id, entries[id].title, entries[id].weekNumber, false);
    }

    /// @notice Citizens can view personal entries
    function viewEntry(uint256 id) external view returns (PersonalEntry memory) {
        return entries[id];
    }
}
