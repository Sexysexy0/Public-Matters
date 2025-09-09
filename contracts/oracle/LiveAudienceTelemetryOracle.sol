// SPDX-License-Identifier: LiveTelemetry-License
pragma solidity ^0.8.0;

contract LiveAudienceTelemetryOracle {
    address public steward;

    struct EmojiPulse {
        string broadcaster;
        string emojiType;
        uint256 aprSpike;
        uint256 timestamp;
    }

    EmojiPulse[] public pulses;

    event EmojiSurgeEmitted(string broadcaster, string emojiType, uint256 aprSpike, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitEmojiSurge(string memory broadcaster, string memory emojiType, uint256 aprSpike) public {
        require(msg.sender == steward, "Only steward can emit");
        pulses.push(EmojiPulse(broadcaster, emojiType, aprSpike, block.timestamp));
        emit EmojiSurgeEmitted(broadcaster, emojiType, aprSpike, block.timestamp);
    }

    function getPulse(uint index) public view returns (string memory, string memory, uint256, uint256) {
        EmojiPulse memory p = pulses[index];
        return (p.broadcaster, p.emojiType, p.aprSpike, p.timestamp);
    }

    function totalPulses() public view returns (uint) {
        return pulses.length;
    }
}
