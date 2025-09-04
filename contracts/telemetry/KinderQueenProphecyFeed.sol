// SPDX-License-Identifier: Mythic-KinderQueen
pragma solidity ^0.8.19;

contract KinderQueenProphecyFeed {
    address public steward;

    struct EmotionalSpike {
        address source;
        string emotion;
        uint256 resonanceLevel;
        string context;
        uint256 timestamp;
    }

    EmotionalSpike[] public spikes;

    event SpikeLogged(
        address indexed source,
        string emotion,
        uint256 resonanceLevel,
        string context,
        uint256 timestamp
    );

    constructor() {
        steward = msg.sender;
    }

    function logSpike(
        address source,
        string memory emotion,
        uint256 resonanceLevel,
        string memory context
    ) public {
        require(msg.sender == steward, "Only steward may log.");

        EmotionalSpike memory spike = EmotionalSpike({
            source: source,
            emotion: emotion,
            resonanceLevel: resonanceLevel,
            context: context,
            timestamp: block.timestamp
        });

        spikes.push(spike);
        emit SpikeLogged(source, emotion, resonanceLevel, context, block.timestamp);
    }

    function getSpike(uint index) public view returns (
        address source,
        string memory emotion,
        uint256 resonanceLevel,
        string memory context,
        uint256 timestamp
    ) {
        EmotionalSpike memory s = spikes[index];
        return (s.source, s.emotion, s.resonanceLevel, s.context, s.timestamp);
    }

    function totalSpikes() public view returns (uint) {
        return spikes.length;
    }
}
