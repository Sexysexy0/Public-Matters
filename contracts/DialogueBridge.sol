// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract DialogueBridge {
    address public overseer;
    uint256 public channelCount;

    struct Channel {
        uint256 id;
        string party;
        string purpose;
        uint256 timestamp;
    }

    mapping(uint256 => Channel) public channels;
    event ChannelOpened(uint256 indexed id, string party, string purpose);

    constructor(address _overseer) {
        overseer = _overseer;
    }

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    function openChannel(string calldata party, string calldata purpose) external onlyOverseer {
        channelCount++;
        channels[channelCount] = Channel(channelCount, party, purpose, block.timestamp);
        emit ChannelOpened(channelCount, party, purpose);
    }
}
