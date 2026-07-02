// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract GlobalJusticeLedger {
    address public overseer;
    uint256 public caseCount;

    struct Case {
        uint256 id;
        string principle;   // Justice, Fair Trial, Equality
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => Case) public cases;
    event CaseDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) {
        overseer = _overseer;
    }

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    function declareCase(string calldata principle, string calldata description) external onlyOverseer {
        caseCount++;
        cases[caseCount] = Case(caseCount, principle, description, block.timestamp);
        emit CaseDeclared(caseCount, principle, description);
    }
}
