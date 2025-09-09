// SPDX-License-Identifier: SignalCascadeContinuity-License
pragma solidity ^0.8.0;

contract SignalCascadeContinuityOracle {
    address public steward;

    struct CascadeSignal {
        string signalID;
        string originSanctum;
        bool cascadeConfirmed;
        string clauseTriggered;
        uint256 timestamp;
    }

    CascadeSignal[] public signals;

    event CascadeEmitted(string signalID, string originSanctum, bool cascadeConfirmed, string clauseTriggered, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitCascade(string memory signalID, string memory originSanctum, bool cascadeConfirmed, string memory clauseTriggered) public {
        require(msg.sender == steward, "Only steward can emit");
        signals.push(CascadeSignal(signalID, originSanctum, cascadeConfirmed, clauseTriggered, block.timestamp));
        emit CascadeEmitted(signalID, originSanctum, cascadeConfirmed, clauseTriggered, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, bool, string memory, uint256) {
        CascadeSignal memory s = signals[index];
        return (s.signalID, s.originSanctum, s.cascadeConfirmed, s.clauseTriggered, s.timestamp);
    }
}
