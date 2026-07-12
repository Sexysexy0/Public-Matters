// SPDX-License-Identifier: MIT
// Contract Name: AppliedCreativityCovenant
// Purpose: Encode applied creativity discipline — execution + storytelling + AI risk management
// Source: Inspired by Accenture white paper "Applied creativity—and how to lead it" (June 2026)
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract AppliedCreativityCovenant {
    address public chiefOperator;

    struct CreativityRecord {
        string principle;   // e.g. Inventive creativity, Expressive creativity, Judgment
        string mechanism;   // e.g. Execution discipline, Storytelling, AI differentiation
        string sector;      // e.g. Business, Brand, Workforce, Governance
        string outcome;     // e.g. Idea executed, People engaged, Value differentiated
        uint256 timestamp;
    }

    CreativityRecord[] public records;

    event CreativityLogged(string principle, string mechanism, string sector, string outcome, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    function logCreativity(
        string memory principle,
        string memory mechanism,
        string memory sector,
        string memory outcome
    ) public onlyChief {
        records.push(CreativityRecord(principle, mechanism, sector, outcome, block.timestamp));
        emit CreativityLogged(principle, mechanism, sector, outcome, block.timestamp);
    }

    function getCreativity(uint256 index) public view returns (
        string memory, string memory, string memory, string memory, uint256
    ) {
        require(index < records.length, "Invalid creativity index");
        CreativityRecord memory cr = records[index];
        return (cr.principle, cr.mechanism, cr.sector, cr.outcome, cr.timestamp);
    }
}
