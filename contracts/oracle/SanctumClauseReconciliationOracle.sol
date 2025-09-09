// SPDX-License-Identifier: SanctumClauseReconciliation-License
pragma solidity ^0.8.0;

contract SanctumClauseReconciliationOracle {
    address public steward;

    struct ReconciliationSignal {
        string clauseID;
        string originSanctum;
        bool reconciled;
        string signalType;
        uint256 timestamp;
    }

    ReconciliationSignal[] public signals;

    event ReconciliationEmitted(string clauseID, string originSanctum, bool reconciled, string signalType, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitReconciliation(string memory clauseID, string memory originSanctum, bool reconciled, string memory signalType) public {
        require(msg.sender == steward, "Only steward can emit");
        signals.push(ReconciliationSignal(clauseID, originSanctum, reconciled, signalType, block.timestamp));
        emit ReconciliationEmitted(clauseID, originSanctum, reconciled, signalType, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, bool, string memory, uint256) {
        ReconciliationSignal memory s = signals[index];
        return (s.clauseID, s.originSanctum, s.reconciled, s.signalType, s.timestamp);
    }
}
