// SPDX-License-Identifier: WorkerSignalTelemetry-License
pragma solidity ^0.8.0;

contract WorkerSignalTelemetryOracle {
    address public steward;

    struct SignalPulse {
        string workerID;
        string sanctumSite;
        string signalType;
        bool clauseTriggered;
        uint256 timestamp;
    }

    SignalPulse[] public pulses;

    event SignalEmitted(string workerID, string sanctumSite, string signalType, bool clauseTriggered, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitSignal(string memory workerID, string memory sanctumSite, string memory signalType, bool clauseTriggered) public {
        require(msg.sender == steward, "Only steward can emit");
        pulses.push(SignalPulse(workerID, sanctumSite, signalType, clauseTriggered, block.timestamp));
        emit SignalEmitted(workerID, sanctumSite, signalType, clauseTriggered, block.timestamp);
    }

    function getPulse(uint index) public view returns (string memory, string memory, string memory, bool, uint256) {
        SignalPulse memory p = pulses[index];
        return (p.workerID, p.sanctumSite, p.signalType, p.clauseTriggered, p.timestamp);
    }
}
