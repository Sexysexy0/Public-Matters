// SPDX-License-Identifier: TreatyBlessingPulse-License
pragma solidity ^0.8.0;

contract TreatyBlessingPulseOracle {
    address public steward;

    struct PulseSignal {
        string treatyName;
        string originPair;
        string blessingType;
        bool pulseConfirmed;
        uint256 timestamp;
    }

    PulseSignal[] public signals;

    event TreatyBlessingPulseEmitted(string treatyName, string originPair, string blessingType, bool pulseConfirmed, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitPulse(string memory treatyName, string memory originPair, string memory blessingType, bool pulseConfirmed) public {
        require(msg.sender == steward, "Only steward can emit");
        signals.push(PulseSignal(treatyName, originPair, blessingType, pulseConfirmed, block.timestamp));
        emit TreatyBlessingPulseEmitted(treatyName, originPair, blessingType, pulseConfirmed, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, string memory, bool, uint256) {
        PulseSignal memory s = signals[index];
        return (s.treatyName, s.originPair, s.blessingType, s.pulseConfirmed, s.timestamp);
    }
}
