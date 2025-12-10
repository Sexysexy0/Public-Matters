// contracts/StoryLedger.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title StoryLedger
 * @notice Log narratives, reflections, and communal myths; publicly viewable ledger.
 */
contract StoryLedger {
    struct Story {
        string title;
        string content;
        address author;
        uint256 timestamp;
    }

    Story[] public stories;

    event StoryLogged(string title, address indexed author, uint256 timestamp);

    function logStory(string calldata title, string calldata content) external {
        stories.push(Story(title, content, msg.sender, block.timestamp));
        emit StoryLogged(title, msg.sender, block.timestamp);
    }

    function totalStories() external view returns (uint256) {
        return stories.length;
    }

    function getStory(uint256 id) external view returns (Story memory) {
        require(id < stories.length, "Invalid id");
        return stories[id];
    }
}
