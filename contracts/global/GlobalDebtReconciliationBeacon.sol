// SPDX-License-Identifier: DebtSanctum
pragma solidity ^0.8.19;

contract GlobalDebtReconciliationBeacon {
    struct DebtEvent {
        string country;
        uint256 externalDebtUSD;
        bool inIMFProgram;
        bool restructuringInitiated;
        string reconciliationMessage;
        bool treatyCompliant;
    }

    mapping(bytes32 => DebtEvent) public events;

    event DebtTagged(string country, uint256 externalDebtUSD);
    event ReconciliationBroadcasted(string country, string reconciliationMessage);

    function tagDebtEvent(string memory country, uint256 externalDebtUSD, bool inIMFProgram, bool restructuringInitiated, string memory reconciliationMessage, bool treatyCompliant) public {
        bytes32 eventId = keccak256(abi.encodePacked(country, block.timestamp));
        events[eventId] = DebtEvent(country, externalDebtUSD, inIMFProgram, restructuringInitiated, reconciliationMessage, treatyCompliant);
        emit DebtTagged(country, externalDebtUSD);
    }

    function broadcastReconciliation(string memory country, string memory reconciliationMessage) public {
        bytes32 eventId = keccak256(abi.encodePacked(country, block.timestamp));
        events[eventId].reconciliationMessage = reconciliationMessage;
        emit ReconciliationBroadcasted(country, reconciliationMessage);
    }

    function getDebtStatus(string memory country) public view returns (DebtEvent memory) {
        bytes32 eventId = keccak256(abi.encodePacked(country, block.timestamp));
        return events[eventId];
    }
}
