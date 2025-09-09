// SPDX-License-Identifier: ComedyTreaty-License
pragma solidity ^0.8.0;

contract ComedyTreatyClauseKit {
    address public steward;

    struct TreatyClause {
        string clauseTitle;
        string civicTheme;
        string impactLevel;
        uint256 timestamp;
    }

    TreatyClause[] public clauses;

    event SatireClauseCodified(string clauseTitle, string civicTheme, string impactLevel, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function codifyClause(string memory clauseTitle, string memory civicTheme, string memory impactLevel) public {
        require(msg.sender == steward, "Only steward can codify");
        clauses.push(TreatyClause(clauseTitle, civicTheme, impactLevel, block.timestamp));
        emit SatireClauseCodified(clauseTitle, civicTheme, impactLevel, block.timestamp);
    }

    function getClause(uint index) public view returns (string memory, string memory, string memory, uint256) {
        TreatyClause memory c = clauses[index];
        return (c.clauseTitle, c.civicTheme, c.impactLevel, c.timestamp);
    }

    function totalClauses() public view returns (uint) {
        return clauses.length;
    }
}
