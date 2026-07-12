// SPDX-License-Identifier: MIT
// Contract Name: ResearchImpactCovenant
// Purpose: Encode research impact + societal value principles in governance
// Source: Inspired by Clarivate Web of Science Research Intelligence (June 25, 2026)
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract ResearchImpactCovenant {
    address public chiefOperator;

    struct ImpactRecord {
        string principle;   // e.g. Research impact, Societal value, Evidence-based decision
        string signal;      // e.g. Funding alignment, Collaboration pathway, Policy adoption
        string sector;      // e.g. Academia, Healthcare, Technology, Public policy
        string outcome;     // e.g. Impact observed, Potential pathway identified, Value demonstrated
        uint256 timestamp;
    }

    ImpactRecord[] public records;

    event ImpactLogged(string principle, string signal, string sector, string outcome, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    function logImpact(
        string memory principle,
        string memory signal,
        string memory sector,
        string memory outcome
    ) public onlyChief {
        records.push(ImpactRecord(principle, signal, sector, outcome, block.timestamp));
        emit ImpactLogged(principle, signal, sector, outcome, block.timestamp);
    }

    function getImpact(uint256 index) public view returns (
        string memory, string memory, string memory, string memory, uint256
    ) {
        require(index < records.length, "Invalid impact index");
        ImpactRecord memory ir = records[index];
        return (ir.principle, ir.signal, ir.sector, ir.outcome, ir.timestamp);
    }
}
