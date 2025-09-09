// SPDX-License-Identifier: VictimSignalTelemetry-License
pragma solidity ^0.8.0;

contract VictimSignalTelemetryOracle {
    address public steward;

    struct VictimSignal {
        string victimID;
        string region;
        bool signalConfirmed;
        string griefType;
        uint256 timestamp;
    }

    VictimSignal[] public signals;

    event VictimSignalEmitted(string victimID, string region, bool signalConfirmed, string griefType, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitSignal(string memory victimID, string memory region, bool signalConfirmed, string memory griefType) public {
        require(msg.sender == steward, "Only steward can emit");
        signals.push(VictimSignal(victimID, region, signalConfirmed, griefType, block.timestamp));
        emit VictimSignalEmitted(victimID, region, signalConfirmed, griefType, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, bool, string memory, uint256) {
        VictimSignal memory s = signals[index];
        return (s.victimID, s.region, s.signalConfirmed, s.griefType, s.timestamp);
    }
}
