// SPDX-License-Identifier: ExecutiveSanctumBalance-License
pragma solidity ^0.8.0;

contract ExecutiveSanctumBalanceOracle {
    address public steward;

    struct SanctumSignal {
        string clauseID;
        string originEntity;
        bool balanceConfirmed;
        string signalType;
        uint256 timestamp;
    }

    SanctumSignal[] public signals;

    event BalanceEmitted(string clauseID, string originEntity, bool balanceConfirmed, string signalType, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitBalance(string memory clauseID, string memory originEntity, bool balanceConfirmed, string memory signalType) public {
        require(msg.sender == steward, "Only steward can emit");
        signals.push(SanctumSignal(clauseID, originEntity, balanceConfirmed, signalType, block.timestamp));
        emit BalanceEmitted(clauseID, originEntity, balanceConfirmed, signalType, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, bool, string memory, uint256) {
        SanctumSignal memory s = signals[index];
        return (s.clauseID, s.originEntity, s.balanceConfirmed, s.signalType, s.timestamp);
    }
}
