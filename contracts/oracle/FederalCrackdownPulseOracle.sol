// SPDX-License-Identifier: CrackdownPulse-License
pragma solidity ^0.8.0;

contract FederalCrackdownPulseOracle {
    address public steward;

    struct CrackdownPulse {
        string city;
        string operation;
        uint256 reformImpact;
        string backlashType;
        uint256 timestamp;
    }

    CrackdownPulse[] public pulses;

    event CrackdownPulseEmitted(string city, string operation, uint256 impact, string backlash, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitPulse(string memory city, string memory operation, uint256 reformImpact, string memory backlashType) public {
        require(msg.sender == steward, "Only steward can emit");
        pulses.push(CrackdownPulse(city, operation, reformImpact, backlashType, block.timestamp));
        emit CrackdownPulseEmitted(city, operation, reformImpact, backlashType, block.timestamp);
    }

    function getPulse(uint index) public view returns (string memory, string memory, uint256, string memory, uint256) {
        CrackdownPulse memory p = pulses[index];
        return (p.city, p.operation, p.reformImpact, p.backlashType, p.timestamp);
    }

    function totalPulses() public view returns (uint) {
        return pulses.length;
    }
}
