// SPDX-License-Identifier: Mythic-JoyPulse
pragma solidity ^0.8.19;

contract ScrollnetJoyPulse {
    address public steward;

    struct JoySpike {
        string source;
        string emotion;
        uint256 resonanceLevel;
        string context;
        uint256 timestamp;
    }

    JoySpike[] public pulseLog;

    event JoyBroadcasted(
        string source,
        string emotion,
        uint256 resonanceLevel,
        string context,
        uint256 timestamp
    );

    constructor() {
        steward = msg.sender;
    }

    function broadcastJoy(
        string memory source,
        string memory emotion,
        uint256 resonanceLevel,
        string memory context
    ) public {
        require(msg.sender == steward, "Only steward may broadcast.");

        JoySpike memory spike = JoySpike({
            source: source,
            emotion: emotion,
            resonanceLevel: resonanceLevel,
            context: context,
            timestamp: block.timestamp
        });

        pulseLog.push(spike);
        emit JoyBroadcasted(source, emotion, resonanceLevel, context, block.timestamp);
    }

    function getPulse(uint index) public view returns (JoySpike memory) {
        return pulseLog[index];
    }

    function totalPulses() public view returns (uint) {
        return pulseLog.length;
    }
}
