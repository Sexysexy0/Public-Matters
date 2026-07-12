// SPDX-License-Identifier: MIT
// Contract Name: MetaSkillsCultureCovenant
// Purpose: Encode communities of practice + learning organisation principles
// Source: Grounded in Spencer & Lucas 2021 (learning culture, communities of practice)
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract MetaSkillsCultureCovenant {
    address public chiefOperator;

    struct CultureRecord {
        string principle;   // e.g. Community of Practice, Learning Organisation
        string action;      // e.g. Peer mentoring, Shared reflection, Continuous improvement
        string outcome;     // e.g. Trust, Collaboration, Resilience
        uint256 timestamp;
    }

    CultureRecord[] public cultures;

    event CultureLogged(string principle, string action, string outcome, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    function logCulture(
        string memory principle,
        string memory action,
        string memory outcome
    ) public onlyChief {
        cultures.push(CultureRecord(principle, action, outcome, block.timestamp));
        emit CultureLogged(principle, action, outcome, block.timestamp);
    }

    function getCulture(uint256 index) public view returns (
        string memory, string memory, string memory, uint256
    ) {
        require(index < cultures.length, "Invalid culture index");
        CultureRecord memory cr = cultures[index];
        return (cr.principle, cr.action, cr.outcome, cr.timestamp);
    }
}
