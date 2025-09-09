// SPDX-License-Identifier: OppositionClauseOverride-License
pragma solidity ^0.8.0;

contract OppositionClauseOverrideRouter {
    address public steward;

    struct OverrideSignal {
        string clauseID;
        string oppositionBloc;
        bool overrideAttempted;
        string overrideType;
        uint256 timestamp;
    }

    OverrideSignal[] public signals;

    event OverrideRouted(string clauseID, string oppositionBloc, bool overrideAttempted, string overrideType, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function routeOverride(string memory clauseID, string memory oppositionBloc, bool overrideAttempted, string memory overrideType) public {
        require(msg.sender == steward, "Only steward can route");
        signals.push(OverrideSignal(clauseID, oppositionBloc, overrideAttempted, overrideType, block.timestamp));
        emit OverrideRouted(clauseID, oppositionBloc, overrideAttempted, overrideType, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, bool, string memory, uint256) {
        OverrideSignal memory o = signals[index];
        return (o.clauseID, o.oppositionBloc, o.overrideAttempted, o.overrideType, o.timestamp);
    }
}
