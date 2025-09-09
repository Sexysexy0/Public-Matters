// SPDX-License-Identifier: CannabisClemencyOracle-License
pragma solidity ^0.8.0;

contract CannabisClemencyOracle {
    address public steward;

    struct ClemencyPulse {
        string jurisdiction;
        string recipient;
        string clemencyType;
        bool reentryActivated;
        uint256 timestamp;
    }

    ClemencyPulse[] public pulses;

    event ClemencyPulseEmitted(string jurisdiction, string recipient, string clemencyType, bool reentry, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitPulse(string memory jurisdiction, string memory recipient, string memory clemencyType, bool reentryActivated) public {
        require(msg.sender == steward, "Only steward can emit");
        pulses.push(ClemencyPulse(jurisdiction, recipient, clemencyType, reentryActivated, block.timestamp));
        emit ClemencyPulseEmitted(jurisdiction, recipient, clemencyType, reentryActivated, block.timestamp);
    }

    function getPulse(uint index) public view returns (string memory, string memory, string memory, bool, uint256) {
        ClemencyPulse memory p = pulses[index];
        return (p.jurisdiction, p.recipient, p.clemencyType, p.reentryActivated, p.timestamp);
    }
}
