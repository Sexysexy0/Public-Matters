// SPDX-License-Identifier: Signal-Sovereignty-License  
pragma solidity ^0.8.19;

contract SignalSanctumShield {
    struct Disruption {
        string sourceNation;
        string affectedSystem;
        bool recovered;
        uint timestamp;
    }

    Disruption[] public disruptionLog;

    event SignalRecovered(string affectedSystem);

    function logDisruption(string memory sourceNation, string memory affectedSystem) public {
        disruptionLog.push(Disruption(sourceNation, affectedSystem, true, block.timestamp));
        emit SignalRecovered(affectedSystem);
    }

    function totalDisruptions() public view returns (uint) {
        return disruptionLog.length;
    }
}
