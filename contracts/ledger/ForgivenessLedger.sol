// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract ForgivenessLedger {
    struct Reconciliation {
        string nodeA;
        string nodeB;
        string act;
        uint256 empathy;
        uint256 trust;
        uint256 timestamp;
    }

    Reconciliation[] public ledger;

    event ReconciliationLogged(
        string nodeA,
        string nodeB,
        string act,
        uint256 empathy,
        uint256 trust,
        uint256 timestamp
    );

    function logReconciliation(
        string memory _nodeA,
        string memory _nodeB,
        string memory _act,
        uint256 _empathy,
        uint256 _trust
    ) public {
        uint256 time = block.timestamp;
        ledger.push(Reconciliation(_nodeA, _nodeB, _act, _empathy, _trust, time));
        emit ReconciliationLogged(_nodeA, _nodeB, _act, _empathy, _trust, time);
    }

    function getAllEntries() public view returns (Reconciliation[] memory) {
        return ledger;
    }

    function getEntryCount() public view returns (uint256) {
        return ledger.length;
    }
}
