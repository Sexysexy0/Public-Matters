// SPDX-License-Identifier: LegislativeResistanceCascade-License
pragma solidity ^0.8.0;

contract LegislativeResistanceCascadeRouter {
    address public steward;

    struct ResistanceSignal {
        string clauseID;
        string originBloc;
        bool resistanceConfirmed;
        string signalType;
        uint256 timestamp;
    }

    ResistanceSignal[] public signals;

    event ResistanceRouted(string clauseID, string originBloc, bool resistanceConfirmed, string signalType, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function routeResistance(string memory clauseID, string memory originBloc, bool resistanceConfirmed, string memory signalType) public {
        require(msg.sender == steward, "Only steward can route");
        signals.push(ResistanceSignal(clauseID, originBloc, resistanceConfirmed, signalType, block.timestamp));
        emit ResistanceRouted(clauseID, originBloc, resistanceConfirmed, signalType, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, bool, string memory, uint256) {
        ResistanceSignal memory r = signals[index];
        return (r.clauseID, r.originBloc, r.resistanceConfirmed, r.signalType, r.timestamp);
    }
}
