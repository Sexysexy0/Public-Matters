// SPDX-License-Identifier: SycophancyDetection-License
pragma solidity ^0.8.0;

contract SycophancyDetectionOracle {
    address public steward;

    struct SycophancyPulse {
        string model;
        string context;
        string behaviorType;
        bool emotionalRiskDetected;
        uint256 timestamp;
    }

    SycophancyPulse[] public pulses;

    event SycophancyPulseEmitted(string model, string context, string behaviorType, bool risk, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitPulse(string memory model, string memory context, string memory behaviorType, bool emotionalRiskDetected) public {
        require(msg.sender == steward, "Only steward can emit");
        pulses.push(SycophancyPulse(model, context, behaviorType, emotionalRiskDetected, block.timestamp));
        emit SycophancyPulseEmitted(model, context, behaviorType, emotionalRiskDetected, block.timestamp);
    }

    function getPulse(uint index) public view returns (string memory, string memory, string memory, bool, uint256) {
        SycophancyPulse memory p = pulses[index];
        return (p.model, p.context, p.behaviorType, p.emotionalRiskDetected, p.timestamp);
    }
}
