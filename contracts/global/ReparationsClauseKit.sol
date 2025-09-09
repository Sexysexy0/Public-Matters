// SPDX-License-Identifier: ReparationsClause-License
pragma solidity ^0.8.0;

contract ReparationsClauseKit {
    address public steward;

    struct ReparationClause {
        string actor;
        string pledge;
        string restorationAct;
        bool verified;
        uint256 timestamp;
    }

    ReparationClause[] public clauses;

    event ReparationClauseLogged(string actor, string pledge, string restoration, bool verified, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function logClause(string memory actor, string memory pledge, string memory restorationAct, bool verified) public {
        require(msg.sender == steward, "Only steward can log");
        clauses.push(ReparationClause(actor, pledge, restorationAct, verified, block.timestamp));
        emit ReparationClauseLogged(actor, pledge, restorationAct, verified, block.timestamp);
    }

    function getClause(uint index) public view returns (string memory, string memory, string memory, bool, uint256) {
        ReparationClause memory c = clauses[index];
        return (c.actor, c.pledge, c.restorationAct, c.verified, c.timestamp);
    }
}
