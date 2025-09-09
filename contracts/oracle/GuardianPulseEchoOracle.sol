// SPDX-License-Identifier: GuardianPulseEcho-License
pragma solidity ^0.8.0;

contract GuardianPulseEchoOracle {
    address public steward;

    struct GuardianPulse {
        string guardian;
        string sanctumZone;
        string reformTriggered;
        uint256 timestamp;
    }

    GuardianPulse[] public pulses;

    event GuardianPulseEmitted(string guardian, string zone, string reform, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitPulse(string memory guardian, string memory sanctumZone, string memory reformTriggered) public {
        require(msg.sender == steward, "Only steward can emit");
        pulses.push(GuardianPulse(guardian, sanctumZone, reformTriggered, block.timestamp));
        emit GuardianPulseEmitted(guardian, sanctumZone, reformTriggered, block.timestamp);
    }

    function getPulse(uint index) public view returns (string memory, string memory, string memory, uint256) {
        GuardianPulse memory p = pulses[index];
        return (p.guardian, p.sanctumZone, p.reformTriggered, p.timestamp);
    }
}
