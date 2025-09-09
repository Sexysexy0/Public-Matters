// SPDX-License-Identifier: LaborSanctumTreatyContinuity-License
pragma solidity ^0.8.0;

contract LaborSanctumTreatyContinuityOracle {
    address public steward;

    struct TreatySignal {
        string workerID;
        string treatyID;
        bool continuityConfirmed;
        string clauseType;
        uint256 timestamp;
    }

    TreatySignal[] public signals;

    event TreatyContinuityEmitted(string workerID, string treatyID, bool continuityConfirmed, string clauseType, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitContinuity(string memory workerID, string memory treatyID, bool continuityConfirmed, string memory clauseType) public {
        require(msg.sender == steward, "Only steward can emit");
        signals.push(TreatySignal(workerID, treatyID, continuityConfirmed, clauseType, block.timestamp));
        emit TreatyContinuityEmitted(workerID, treatyID, continuityConfirmed, clauseType, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, bool, string memory, uint256) {
        TreatySignal memory s = signals[index];
        return (s.workerID, s.treatyID, s.continuityConfirmed, s.clauseType, s.timestamp);
    }
}
