// SPDX-License-Identifier: LoyaltyClauseOverride-License
pragma solidity ^0.8.0;

contract LoyaltyClauseOverrideOracle {
    address public steward;

    struct OverrideSignal {
        string stewardID;
        string clauseID;
        bool overrideAttempted;
        string overrideReason;
        uint256 timestamp;
    }

    OverrideSignal[] public signals;

    event OverrideEmitted(string stewardID, string clauseID, bool overrideAttempted, string overrideReason, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitOverride(string memory stewardID, string memory clauseID, bool overrideAttempted, string memory overrideReason) public {
        require(msg.sender == steward, "Only steward can emit");
        signals.push(OverrideSignal(stewardID, clauseID, overrideAttempted, overrideReason, block.timestamp));
        emit OverrideEmitted(stewardID, clauseID, overrideAttempted, overrideReason, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, bool, string memory, uint256) {
        OverrideSignal memory s = signals[index];
        return (s.stewardID, s.clauseID, s.overrideAttempted, s.overrideReason, s.timestamp);
    }
}
