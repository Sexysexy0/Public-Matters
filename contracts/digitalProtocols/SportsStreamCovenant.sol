// SPDX-License-Identifier: Stream-Justice
pragma solidity ^0.8.19;

contract SportsStreamCovenant {
    struct StreamClause {
        string league;
        string piracyLevel;
        string damayClause;
        bool overrideActive;
    }

    StreamClause[] public clauses;

    constructor() {
        clauses.push(StreamClause("Premier League", "High", "Creator dignity clause", false));
        clauses.push(StreamClause("LaLiga", "Critical", "Fair access clause", false));
    }

    function activateOverride(uint index) public {
        clauses[index].overrideActive = true;
        clauses[index].damayClause = "Restoration broadcasted";
    }
}
