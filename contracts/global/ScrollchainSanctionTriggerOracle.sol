// SPDX-License-Identifier: SanctionTrigger-License
pragma solidity ^0.8.0;

contract ScrollchainSanctionTriggerOracle {
    address public steward;

    struct SanctionPulse {
        string actor;
        string violation;
        string reformTriggered;
        uint256 timestamp;
    }

    SanctionPulse[] public pulses;

    event SanctionPulseEmitted(string actor, string violation, string reform, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitPulse(string memory actor, string memory violation, string memory reformTriggered) public {
        require(msg.sender == steward, "Only steward can emit");
        pulses.push(SanctionPulse(actor, violation, reformTriggered, block.timestamp));
        emit SanctionPulseEmitted(actor, violation, reformTriggered, block.timestamp);
    }

    function getPulse(uint index) public view returns (string memory, string memory, string memory, uint256) {
        SanctionPulse memory p = pulses[index];
        return (p.actor, p.violation, p.reformTriggered, p.timestamp);
    }
}
