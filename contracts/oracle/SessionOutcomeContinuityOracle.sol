// SPDX-License-Identifier: SessionOutcomeContinuity-License
pragma solidity ^0.8.0;

contract SessionOutcomeContinuityOracle {
    address public steward;

    struct OutcomeSignal {
        string clauseID;
        string sessionID;
        bool passed;
        string overrideStatus;
        uint256 timestamp;
    }

    OutcomeSignal[] public signals;

    event OutcomeEmitted(string clauseID, string sessionID, bool passed, string overrideStatus, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitOutcome(string memory clauseID, string memory sessionID, bool passed, string memory overrideStatus) public {
        require(msg.sender == steward, "Only steward can emit");
        signals.push(OutcomeSignal(clauseID, sessionID, passed, overrideStatus, block.timestamp));
        emit OutcomeEmitted(clauseID, sessionID, passed, overrideStatus, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, bool, string memory, uint256) {
        OutcomeSignal memory s = signals[index];
        return (s.clauseID, s.sessionID, s.passed, s.overrideStatus, s.timestamp);
    }
}
