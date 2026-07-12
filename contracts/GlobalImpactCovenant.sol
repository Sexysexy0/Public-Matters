// SPDX-License-Identifier: MIT
// Contract Name: GlobalImpactCovenant
// Purpose: Encode global R&D impact + SDG alignment principles in governance
// Source: Inspired by Clarivate G20 R&D Scorecard 2026
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract GlobalImpactCovenant {
    address public chiefOperator;

    struct ImpactRecord {
        string principle;   // e.g. Global impact, SDG alignment, Knowledge transfer
        string indicator;   // e.g. Non-academic collaboration, Citation uptake, Policy adoption
        string country;     // e.g. Germany, Argentina, Italy, South Africa, Mexico
        string outcome;     // e.g. Impact observed, Collaboration reinforced, Uptake achieved
        uint256 timestamp;
    }

    ImpactRecord[] public records;

    event GlobalImpactLogged(string principle, string indicator, string country, string outcome, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    function logGlobalImpact(
        string memory principle,
        string memory indicator,
        string memory country,
        string memory outcome
    ) public onlyChief {
        records.push(ImpactRecord(principle, indicator, country, outcome, block.timestamp));
        emit GlobalImpactLogged(principle, indicator, country, outcome, block.timestamp);
    }

    function getGlobalImpact(uint256 index) public view returns (
        string memory, string memory, string memory, string memory, uint256
    ) {
        require(index < records.length, "Invalid global impact index");
        ImpactRecord memory gr = records[index];
        return (gr.principle, gr.indicator, gr.country, gr.outcome, gr.timestamp);
    }
}
