// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title EnlightenmentBroadcast
 * @dev Manages the immutable distribution of life lessons and reflective content.
 */
contract EnlightenmentBroadcast {
    struct Message {
        string content;
        string lesson;
        uint256 timestamp;
        uint256 reach; // Track how many lives were 'reflected'
    }

    mapping(uint256 => Message) public archive;
    uint256 public totalBroadcasts;
    address public immutable storyteller;

    event LightShared(uint256 indexed id, string lesson);

    constructor() {
        storyteller = msg.sender; // Vin as the Master Architect of the Narrative
    }

    // [Goal: Broadcast a reflective lesson to the world wide web/chain]
    function shareLight(string memory _content, string memory _lesson) external {
        require(msg.sender == storyteller, "ERROR: Unauthorized broadcast.");
        
        totalBroadcasts++;
        archive[totalBroadcasts] = Message({
            content: _content,
            lesson: _lesson,
            timestamp: block.timestamp,
            reach: 0 
        });

        emit LightShared(totalBroadcasts, _lesson);
    }

    function recordImpact(uint256 _id) external {
        // Logic: Increment impact when someone is 'enlightened' by the story
        archive[_id].reach++;
    }
}
