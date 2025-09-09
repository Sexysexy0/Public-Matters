// SPDX-License-Identifier: ConstitutionalBalanceSignal-License
pragma solidity ^0.8.0;

contract ConstitutionalBalanceSignalRouter {
    address public steward;

    struct ReformSignal {
        string clauseID;
        string originEntity;
        bool reformConfirmed;
        string signalType;
        uint256 timestamp;
    }

    ReformSignal[] public signals;

    event ReformRouted(string clauseID, string originEntity, bool reformConfirmed, string signalType, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function routeSignal(string memory clauseID, string memory originEntity, bool reformConfirmed, string memory signalType) public {
        require(msg.sender == steward, "Only steward can route");
        signals.push(ReformSignal(clauseID, originEntity, reformConfirmed, signalType, block.timestamp));
        emit ReformRouted(clauseID, originEntity, reformConfirmed, signalType, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, bool, string memory, uint256) {
        ReformSignal memory s = signals[index];
        return (s.clauseID, s.originEntity, s.reformConfirmed, s.signalType, s.timestamp);
    }
}
