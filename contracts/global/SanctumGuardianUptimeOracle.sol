// SPDX-License-Identifier: GuardianUptime-License
pragma solidity ^0.8.0;

contract SanctumGuardianUptimeOracle {
    address public steward;

    struct GuardianPulse {
        string guardian;
        string sanctum;
        string eventType;
        string blessingType;
        uint256 timestamp;
    }

    GuardianPulse[] public pulses;

    event GuardianPulseEmitted(string guardian, string sanctum, string eventType, string blessingType, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitPulse(string memory guardian, string memory sanctum, string memory eventType, string memory blessingType) public {
        require(msg.sender == steward, "Only steward can emit");
        pulses.push(GuardianPulse(guardian, sanctum, eventType, blessingType, block.timestamp));
        emit GuardianPulseEmitted(guardian, sanctum, eventType, blessingType, block.timestamp);
    }

    function getPulse(uint index) public view returns (string memory, string memory, string memory, string memory, uint256) {
        GuardianPulse memory p = pulses[index];
        return (p.guardian, p.sanctum, p.eventType, p.blessingType, p.timestamp);
    }
}
