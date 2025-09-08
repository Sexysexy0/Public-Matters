// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

contract BitMarketJoyTelemetry {
    address public steward;
    uint public totalJoyEvents;

    struct JoyPulse {
        string missionTitle;
        string participant;
        uint aprScore;
        string rippleZone;
        uint timestamp;
    }

    JoyPulse[] public joyLog;

    event JoyLogged(string missionTitle, string participant, uint aprScore, string rippleZone, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function logJoyPulse(
        string memory missionTitle,
        string memory participant,
        uint aprScore,
        string memory rippleZone
    ) public {
        require(aprScore >= 0 && aprScore <= 100, "APR score must be between 0 and 100");
        JoyPulse memory pulse = JoyPulse(missionTitle, participant, aprScore, rippleZone, block.timestamp);
        joyLog.push(pulse);
        totalJoyEvents++;
        emit JoyLogged(missionTitle, participant, aprScore, rippleZone, block.timestamp);
    }

    function getJoyPulse(uint index) public view returns (
        string memory missionTitle,
        string memory participant,
        uint aprScore,
        string memory rippleZone,
        uint timestamp
    ) {
        JoyPulse memory pulse = joyLog[index];
        return (pulse.missionTitle, pulse.participant, pulse.aprScore, pulse.rippleZone, pulse.timestamp);
    }

    function getTotalJoyEvents() public view returns (uint) {
        return totalJoyEvents;
    }
}
