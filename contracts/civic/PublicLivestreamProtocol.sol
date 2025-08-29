// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.19;

contract PublicLivestreamProtocol {
    address public steward;

    struct Livestream {
        string eventName;
        string scrollLinked;
        string emotionalTag;
        string mediaNode;
        uint256 timestamp;
    }

    Livestream[] public streams;

    event LivestreamStarted(string eventName, string mediaNode);

    constructor() {
        steward = msg.sender;
    }

    function startLivestream(
        string memory eventName,
        string memory scrollLinked,
        string memory emotionalTag,
        string memory mediaNode
    ) public {
        streams.push(Livestream(eventName, scrollLinked, emotionalTag, mediaNode, block.timestamp));
        emit LivestreamStarted(eventName, mediaNode);
    }

    function getStream(uint256 index) public view returns (Livestream memory) {
        return streams[index];
    }

    function totalStreams() public view returns (uint256) {
        return streams.length;
    }
}
