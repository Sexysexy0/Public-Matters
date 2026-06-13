// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title SpiritualWeeklyCodex
/// @notice Covenant for weekly spiritual storytelling cadence
contract SpiritualWeeklyCodex {
    address public oversightCommittee;
    uint256 public storyCount;

    struct SpiritualStory {
        uint256 id;
        string title;
        string content;
        uint256 weekNumber;
        bool active;
        uint256 timestamp;
    }

    mapping(uint256 => SpiritualStory) public stories;

    event StoryPublished(uint256 indexed id, string title, uint256 weekNumber, bool active);

    modifier onlyOversight() {
        require(msg.sender == oversightCommittee, "Not authorized");
        _;
    }

    constructor(address _oversightCommittee) {
        oversightCommittee = _oversightCommittee;
    }

    /// @notice Oversight publishes one spiritual story per week
    function publishStory(string calldata title, string calldata content, uint256 weekNumber) external onlyOversight {
        storyCount++;
        stories[storyCount] = SpiritualStory({
            id: storyCount,
            title: title,
            content: content,
            weekNumber: weekNumber,
            active: true,
            timestamp: block.timestamp
        });
        emit StoryPublished(storyCount, title, weekNumber, true);
    }

    /// @notice Oversight deactivates a story
    function deactivateStory(uint256 id) external onlyOversight {
        stories[id].active = false;
        emit StoryPublished(id, stories[id].title, stories[id].weekNumber, false);
    }

    /// @notice Citizens can view spiritual stories
    function viewStory(uint256 id) external view returns (SpiritualStory memory) {
        return stories[id];
    }
}
