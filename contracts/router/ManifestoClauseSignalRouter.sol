// SPDX-License-Identifier: ManifestoClauseSignal-License
pragma solidity ^0.8.0;

contract ManifestoClauseSignalRouter {
    address public steward;

    struct ClauseSignal {
        string manifestoID;
        string clauseID;
        bool signalConfirmed;
        string originSanctum;
        uint256 timestamp;
    }

    ClauseSignal[] public signals;

    event SignalRouted(string manifestoID, string clauseID, bool signalConfirmed, string originSanctum, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function routeSignal(string memory manifestoID, string memory clauseID, bool signalConfirmed, string memory originSanctum) public {
        require(msg.sender == steward, "Only steward can route");
        signals.push(ClauseSignal(manifestoID, clauseID, signalConfirmed, originSanctum, block.timestamp));
        emit SignalRouted(manifestoID, clauseID, signalConfirmed, originSanctum, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, bool, string memory, uint256) {
        ClauseSignal memory s = signals[index];
        return (s.manifestoID, s.clauseID, s.signalConfirmed, s.originSanctum, s.timestamp);
    }
}
