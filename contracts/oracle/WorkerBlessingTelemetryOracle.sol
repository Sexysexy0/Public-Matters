// SPDX-License-Identifier: WorkerBlessingTelemetry-License
pragma solidity ^0.8.0;

contract WorkerBlessingTelemetryOracle {
    address public steward;

    struct BlessingSignal {
        string workerID;
        string region;
        bool blessingConfirmed;
        string clauseType;
        uint256 timestamp;
    }

    BlessingSignal[] public signals;

    event BlessingTelemetryEmitted(string workerID, string region, bool blessingConfirmed, string clauseType, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitBlessing(string memory workerID, string memory region, bool blessingConfirmed, string memory clauseType) public {
        require(msg.sender == steward, "Only steward can emit");
        signals.push(BlessingSignal(workerID, region, blessingConfirmed, clauseType, block.timestamp));
        emit BlessingTelemetryEmitted(workerID, region, blessingConfirmed, clauseType, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, bool, string memory, uint256) {
        BlessingSignal memory s = signals[index];
        return (s.workerID, s.region, s.blessingConfirmed, s.clauseType, s.timestamp);
    }
}
