// SPDX-License-Identifier: TreatyGradeSanctumPulse-License
pragma solidity ^0.8.0;

contract TreatyGradeSanctumPulseOracle {
    address public steward;

    struct PulseSignal {
        string stewardID;
        string treatyID;
        bool pulseConfirmed;
        string pulseType;
        uint256 timestamp;
    }

    PulseSignal[] public signals;

    event PulseEmitted(string stewardID, string treatyID, bool pulseConfirmed, string pulseType, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitPulse(string memory stewardID, string memory treatyID, bool pulseConfirmed, string memory pulseType) public {
        require(msg.sender == steward, "Only steward can emit");
        signals.push(PulseSignal(stewardID, treatyID, pulseConfirmed, pulseType, block.timestamp));
        emit PulseEmitted(stewardID, treatyID, pulseConfirmed, pulseType, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, bool, string memory, uint256) {
        PulseSignal memory s = signals[index];
        return (s.stewardID, s.treatyID, s.pulseConfirmed, s.pulseType, s.timestamp);
    }
}
