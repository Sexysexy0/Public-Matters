// SPDX-License-Identifier: LaborClauseOverrideFirewall-License
pragma solidity ^0.8.0;

contract LaborClauseOverrideFirewall {
    address public steward;

    struct OverrideSignal {
        string clauseID;
        string region;
        bool overrideAttempted;
        string overrideType;
        uint256 timestamp;
    }

    OverrideSignal[] public signals;

    event ClauseOverrideBlocked(string clauseID, string region, bool overrideAttempted, string overrideType, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function blockOverride(string memory clauseID, string memory region, bool overrideAttempted, string memory overrideType) public {
        require(msg.sender == steward, "Only steward can block");
        signals.push(OverrideSignal(clauseID, region, overrideAttempted, overrideType, block.timestamp));
        emit ClauseOverrideBlocked(clauseID, region, overrideAttempted, overrideType, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, bool, string memory, uint256) {
        OverrideSignal memory s = signals[index];
        return (s.clauseID, s.region, s.overrideAttempted, s.overrideType, s.timestamp);
    }
}
