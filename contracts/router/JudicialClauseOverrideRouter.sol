// SPDX-License-Identifier: JudicialClauseOverride-License
pragma solidity ^0.8.0;

contract JudicialClauseOverrideRouter {
    address public steward;

    struct OverrideSignal {
        string clauseID;
        string breachType;
        bool overrideConfirmed;
        string sanctumID;
        uint256 timestamp;
    }

    OverrideSignal[] public signals;

    event ClauseOverrideRouted(string clauseID, string breachType, bool overrideConfirmed, string sanctumID, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function routeOverride(string memory clauseID, string memory breachType, bool overrideConfirmed, string memory sanctumID) public {
        require(msg.sender == steward, "Only steward can route");
        signals.push(OverrideSignal(clauseID, breachType, overrideConfirmed, sanctumID, block.timestamp));
        emit ClauseOverrideRouted(clauseID, breachType, overrideConfirmed, sanctumID, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, bool, string memory, uint256) {
        OverrideSignal memory s = signals[index];
        return (s.clauseID, s.breachType, s.overrideConfirmed, s.sanctumID, s.timestamp);
    }
}
