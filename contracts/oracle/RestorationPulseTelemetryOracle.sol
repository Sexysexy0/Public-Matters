// SPDX-License-Identifier: RestorationPulseTelemetry-License
pragma solidity ^0.8.0;

contract RestorationPulseTelemetryOracle {
    address public steward;

    struct PulseSignal {
        string sanctumID;
        string restorationType;
        bool pulseConfirmed;
        string clauseRestored;
        uint256 timestamp;
    }

    PulseSignal[] public signals;

    event RestorationPulseEmitted(string sanctumID, string restorationType, bool pulseConfirmed, string clauseRestored, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitPulse(string memory sanctumID, string memory restorationType, bool pulseConfirmed, string memory clauseRestored) public {
        require(msg.sender == steward, "Only steward can emit");
        signals.push(PulseSignal(sanctumID, restorationType, pulseConfirmed, clauseRestored, block.timestamp));
        emit RestorationPulseEmitted(sanctumID, restorationType, pulseConfirmed, clauseRestored, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, bool, string memory, uint256) {
        PulseSignal memory s = signals[index];
        return (s.sanctumID, s.restorationType, s.pulseConfirmed, s.clauseRestored, s.timestamp);
    }
}
