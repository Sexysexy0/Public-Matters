// SPDX-License-Identifier: ClauseDriftDetection-License
pragma solidity ^0.8.0;

contract ClauseDriftDetectionOracle {
    address public steward;

    struct DriftPulse {
        string clauseID;
        string zone;
        string driftType;
        bool recalibrationRequired;
        uint256 timestamp;
    }

    DriftPulse[] public pulses;

    event DriftPulseEmitted(string clauseID, string zone, string driftType, bool recalibrationRequired, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitPulse(string memory clauseID, string memory zone, string memory driftType, bool recalibrationRequired) public {
        require(msg.sender == steward, "Only steward can emit");
        pulses.push(DriftPulse(clauseID, zone, driftType, recalibrationRequired, block.timestamp));
        emit DriftPulseEmitted(clauseID, zone, driftType, recalibrationRequired, block.timestamp);
    }

    function getPulse(uint index) public view returns (string memory, string memory, string memory, bool, uint256) {
        DriftPulse memory p = pulses[index];
        return (p.clauseID, p.zone, p.driftType, p.recalibrationRequired, p.timestamp);
    }
}
