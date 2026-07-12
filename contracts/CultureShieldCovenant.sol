// SPDX-License-Identifier: MIT
// Contract Name: CultureShieldCovenant
// Purpose: Encode safeguards against toxic company culture (Great Gloom red flags)
// Source: Inspired by BambooHR white paper "Bad Company Culture: 10 Red Flags + How to Fix It"
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract CultureShieldCovenant {
    address public chiefOperator;

    struct CultureRecord {
        string redFlag;     // e.g. Leadership deficit, Work-life imbalance, Gossip
        string fix;         // e.g. Lead by example, Continuous learning, Constructive conflict
        string sector;      // e.g. Workforce, SMBs, Enterprises
        string outcome;     // e.g. Culture stabilized, Burnout reduced, Trust reinforced
        uint256 timestamp;
    }

    CultureRecord[] public records;

    event CultureLogged(string redFlag, string fix, string sector, string outcome, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    function logCulture(
        string memory redFlag,
        string memory fix,
        string memory sector,
        string memory outcome
    ) public onlyChief {
        records.push(CultureRecord(redFlag, fix, sector, outcome, block.timestamp));
        emit CultureLogged(redFlag, fix, sector, outcome, block.timestamp);
    }

    function getCulture(uint256 index) public view returns (
        string memory, string memory, string memory, string memory, uint256
    ) {
        require(index < records.length, "Invalid culture index");
        CultureRecord memory cr = records[index];
        return (cr.redFlag, cr.fix, cr.sector, cr.outcome, cr.timestamp);
    }
}
