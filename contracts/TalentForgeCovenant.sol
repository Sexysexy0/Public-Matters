// SPDX-License-Identifier: MIT
// Contract Name: TalentForgeCovenant
// Purpose: Encode systemic safeguards for nurturing developer talent, training pipelines, scholarships, and skill-building programs
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract TalentForgeCovenant {
    address public chiefOperator;

    struct ForgeRecord {
        string principle;   // e.g. Talent nurturing, Training pipelines, Scholarships, Skill-building
        string mechanism;   // e.g. Grants, Mentorship, Bootcamps, Certification programs
        string sector;      // e.g. Gaming, Technology, Education, Marketplace governance
        string outcome;     // e.g. Skills enhanced, Talent nurtured, Ecosystem strengthened
        uint256 timestamp;
    }

    ForgeRecord[] public records;

    event ForgeLogged(string principle, string mechanism, string sector, string outcome, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    function logForge(
        string memory principle,
        string memory mechanism,
        string memory sector,
        string memory outcome
    ) public onlyChief {
        records.push(ForgeRecord(principle, mechanism, sector, outcome, block.timestamp));
        emit ForgeLogged(principle, mechanism, sector, outcome, block.timestamp);
    }

    function getForge(uint256 index) public view returns (
        string memory, string memory, string memory, string memory, uint256
    ) {
        require(index < records.length, "Invalid forge index");
        ForgeRecord memory fr = records[index];
        return (fr.principle, fr.mechanism, fr.sector, fr.outcome, fr.timestamp);
    }
}
