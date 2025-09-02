// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract DraftClausePack {
    struct Clause {
        string title;
        string body;
        bool validated;
        uint256 timestamp;
    }

    Clause[] public clauses;
    address public steward;

    event ClauseDrafted(string title);

    constructor() {
        steward = msg.sender;
    }

    function draftClause(string memory title, string memory body) external {
        require(msg.sender == steward, "Unauthorized steward");

        clauses.push(Clause(title, body, false, block.timestamp));
        emit ClauseDrafted(title);
    }

    function validateClause(uint256 index) external {
        require(msg.sender == steward, "Unauthorized");
        clauses[index].validated = true;
    }

    function getClause(uint256 index) external view returns (Clause memory) {
        return clauses[index];
    }
}
