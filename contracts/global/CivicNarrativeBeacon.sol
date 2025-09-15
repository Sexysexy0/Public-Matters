// SPDX-License-Identifier: NarrativeSanctum
pragma solidity ^0.8.19;

contract CivicNarrativeBeacon {
    struct CivicStory {
        string stewardName;
        string storyTitle;
        string domain; // e.g. "Education", "Governance", "Culture", "Media"
        string message;
        bool tagged;
        bool broadcasted;
    }

    mapping(bytes32 => CivicStory) public stories;

    event StoryRegistered(string stewardName, string storyTitle);
    event StoryTagged(string storyTitle);
    event StoryBroadcasted(string storyTitle);

    function registerStory(string memory stewardName, string memory storyTitle, string memory domain, string memory message) public {
        bytes32 storyId = keccak256(abi.encodePacked(stewardName, storyTitle, block.timestamp));
        stories[storyId] = CivicStory(stewardName, storyTitle, domain, message, false, false);
        emit StoryRegistered(stewardName, storyTitle);
    }

    function tagStory(string memory stewardName, string memory storyTitle) public {
        bytes32 storyId = keccak256(abi.encodePacked(stewardName, storyTitle, block.timestamp));
        stories[storyId].tagged = true;
        emit StoryTagged(storyTitle);
    }

    function broadcastStory(string memory stewardName, string memory storyTitle) public {
        bytes32 storyId = keccak256(abi.encodePacked(stewardName, storyTitle, block.timestamp));
        stories[storyId].broadcasted = true;
        emit StoryBroadcasted(storyTitle);
    }

    function getStoryStatus(string memory stewardName, string memory storyTitle) public view returns (CivicStory memory) {
        bytes32 storyId = keccak256(abi.encodePacked(stewardName, storyTitle, block.timestamp));
        return stories[storyId];
    }
}
