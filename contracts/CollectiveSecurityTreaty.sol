// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CollectiveSecurityTreaty {
    address public overseer;
    uint256 public clauseCount;

    struct Clause {
        uint256 id;
        string domain;   // Defense, Community, Global
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => Clause) public clauses;
    event ClauseSigned(uint256 indexed id, string domain, string description);

    constructor(address _overseer) {
        overseer = _overseer;
    }

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    function signClause(string calldata domain, string calldata description) external onlyOverseer {
        clauseCount++;
        clauses[clauseCount] = Clause(clauseCount, domain, description, block.timestamp);
        emit ClauseSigned(clauseCount, domain, description);
    }
}
