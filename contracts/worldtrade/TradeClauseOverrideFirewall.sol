// SPDX-License-Identifier: TradeClauseOverrideFirewall-License
pragma solidity ^0.8.0;

contract TradeClauseOverrideFirewall {
    address public steward;

    mapping(string => bool) public overrideBlocked;

    event ClauseOverrideBlocked(string clauseID, string reason, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function blockOverride(string memory clauseID, string memory reason) public {
        require(msg.sender == steward, "Only steward can block");
        overrideBlocked[clauseID] = true;
        emit ClauseOverrideBlocked(clauseID, reason, block.timestamp);
    }

    function isBlocked(string memory clauseID) public view returns (bool) {
        return overrideBlocked[clauseID];
    }
}
