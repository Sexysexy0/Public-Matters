// SPDX-License-Identifier: ClauseFailureSignal-License
pragma solidity ^0.8.0;

contract ClauseFailureSignalRouter {
    address public steward;

    struct FailureSignal {
        string clauseID;
        string originSanctum;
        bool failureConfirmed;
        string breachType;
        uint256 timestamp;
    }

    FailureSignal[] public signals;

    event FailureRouted(string clauseID, string originSanctum, bool failureConfirmed, string breachType, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function routeFailure(string memory clauseID, string memory originSanctum, bool failureConfirmed, string memory breachType) public {
        require(msg.sender == steward, "Only steward can route");
        signals.push(FailureSignal(clauseID, originSanctum, failureConfirmed, breachType, block.timestamp));
        emit FailureRouted(clauseID, originSanctum, failureConfirmed, breachType, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, bool, string memory, uint256) {
        FailureSignal memory s = signals[index];
        return (s.clauseID, s.originSanctum, s.failureConfirmed, s.breachType, s.timestamp);
    }
}
