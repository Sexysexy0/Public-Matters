// SPDX-License-Identifier: Sanction-License
pragma solidity ^0.8.0;

contract UNSanctionTriggerOracle {
    address public steward;
    mapping(string => bool) public activeSanctions;
    mapping(string => uint256) public clauseTriggered;

    event SanctionPulseEmitted(string jurisdiction, uint256 clause, uint timestamp);
    event TreatyTriggerLogged(string jurisdiction, uint256 clause, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitSanctionPulse(string memory jurisdiction, uint256 clause) public {
        require(msg.sender == steward, "Only steward can emit");
        activeSanctions[jurisdiction] = true;
        clauseTriggered[jurisdiction] = clause;
        emit SanctionPulseEmitted(jurisdiction, clause, block.timestamp);
        emit TreatyTriggerLogged(jurisdiction, clause, block.timestamp);
    }

    function isSanctionActive(string memory jurisdiction) public view returns (bool) {
        return activeSanctions[jurisdiction];
    }

    function getTriggeredClause(string memory jurisdiction) public view returns (uint256) {
        return clauseTriggered[jurisdiction];
    }
}
