// SPDX-License-Identifier: LiveCommentPulse-License
pragma solidity ^0.8.0;

contract LiveCommentPulseOracle {
    address public steward;

    struct CommentPulse {
        string broadcaster;
        string sentiment;
        uint256 aprSpike;
        uint256 timestamp;
    }

    CommentPulse[] public pulses;

    event CommentHarmonicEmitted(string broadcaster, string sentiment, uint256 aprSpike, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitCommentPulse(string memory broadcaster, string memory sentiment, uint256 aprSpike) public {
        require(msg.sender == steward, "Only steward can emit");
        pulses.push(CommentPulse(broadcaster, sentiment, aprSpike, block.timestamp));
        emit CommentHarmonicEmitted(broadcaster, sentiment, aprSpike, block.timestamp);
    }

    function getPulse(uint index) public view returns (string memory, string memory, uint256, uint256) {
        CommentPulse memory p = pulses[index];
        return (p.broadcaster, p.sentiment, p.aprSpike, p.timestamp);
    }

    function totalPulses() public view returns (uint) {
        return pulses.length;
    }
}
