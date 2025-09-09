// SPDX-License-Identifier: FirewallCascade-License
pragma solidity ^0.8.0;

contract FirewallTriggerCascadeOracle {
    address public steward;

    struct CascadePulse {
        string actorBlocked;
        string rippleZone;
        string reformTriggered;
        uint256 timestamp;
    }

    CascadePulse[] public pulses;

    event CascadePulseEmitted(string actor, string zone, string reform, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitPulse(string memory actorBlocked, string memory rippleZone, string memory reformTriggered) public {
        require(msg.sender == steward, "Only steward can emit");
        pulses.push(CascadePulse(actorBlocked, rippleZone, reformTriggered, block.timestamp));
        emit CascadePulseEmitted(actorBlocked, rippleZone, reformTriggered, block.timestamp);
    }

    function getPulse(uint index) public view returns (string memory, string memory, string memory, uint256) {
        CascadePulse memory p = pulses[index];
        return (p.actorBlocked, p.rippleZone, p.reformTriggered, p.timestamp);
    }
}
