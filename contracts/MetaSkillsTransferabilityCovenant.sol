// SPDX-License-Identifier: MIT
// Contract Name: MetaSkillsTransferabilityCovenant
// Purpose: Encode cross-sector transfer + contextual adaptability of meta-skills
// Source: Grounded in Spencer & Lucas 2021 (transfer of learning across contexts)
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract MetaSkillsTransferabilityCovenant {
    address public chiefOperator;

    struct Transferability {
        string skill;        // e.g. Critical Thinking, Collaborating, Adapting
        string sectorFrom;   // e.g. Education, Apprenticeship, Governance
        string sectorTo;     // e.g. Workplace, Community, Leadership
        string enabler;      // e.g. Practice, Reflection, Clear models
        uint256 timestamp;
    }

    Transferability[] public transfers;

    event TransferabilityLogged(string skill, string sectorFrom, string sectorTo, string enabler, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    function logTransferability(
        string memory skill,
        string memory sectorFrom,
        string memory sectorTo,
        string memory enabler
    ) public onlyChief {
        transfers.push(Transferability(skill, sectorFrom, sectorTo, enabler, block.timestamp));
        emit TransferabilityLogged(skill, sectorFrom, sectorTo, enabler, block.timestamp);
    }

    function getTransferability(uint256 index) public view returns (
        string memory, string memory, string memory, string memory, uint256
    ) {
        require(index < transfers.length, "Invalid transferability index");
        Transferability memory t = transfers[index];
        return (t.skill, t.sectorFrom, t.sectorTo, t.enabler, t.timestamp);
    }
}
