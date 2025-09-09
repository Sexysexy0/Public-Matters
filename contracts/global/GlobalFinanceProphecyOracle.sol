// SPDX-License-Identifier: FinanceProphecy-License
pragma solidity ^0.8.0;

contract GlobalFinanceProphecyOracle {
    address public steward;

    struct ProphecyPulse {
        string actor;
        string financialAct;
        string rippleEffect;
        uint256 timestamp;
    }

    ProphecyPulse[] public pulses;

    event ProphecyPulseEmitted(string actor, string act, string ripple, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitPulse(string memory actor, string memory financialAct, string memory rippleEffect) public {
        require(msg.sender == steward, "Only steward can emit");
        pulses.push(ProphecyPulse(actor, financialAct, rippleEffect, block.timestamp));
        emit ProphecyPulseEmitted(actor, financialAct, rippleEffect, block.timestamp);
    }

    function getPulse(uint index) public view returns (string memory, string memory, string memory, uint256) {
        ProphecyPulse memory p = pulses[index];
        return (p.actor, p.financialAct, p.rippleEffect, p.timestamp);
    }

    function totalPulses() public view returns (uint) {
        return pulses.length;
    }
}
