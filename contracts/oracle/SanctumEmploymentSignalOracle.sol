// SPDX-License-Identifier: SanctumEmploymentSignal-License
pragma solidity ^0.8.0;

contract SanctumEmploymentSignalOracle {
    address public steward;

    struct EmploymentSignal {
        string workerID;
        string region;
        bool signalConfirmed;
        string sector;
        uint256 timestamp;
    }

    EmploymentSignal[] public signals;

    event EmploymentSignalEmitted(string workerID, string region, bool signalConfirmed, string sector, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitSignal(string memory workerID, string memory region, bool signalConfirmed, string memory sector) public {
        require(msg.sender == steward, "Only steward can emit");
        signals.push(EmploymentSignal(workerID, region, signalConfirmed, sector, block.timestamp));
        emit EmploymentSignalEmitted(workerID, region, signalConfirmed, sector, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, bool, string memory, uint256) {
        EmploymentSignal memory s = signals[index];
        return (s.workerID, s.region, s.signalConfirmed, s.sector, s.timestamp);
    }
}
