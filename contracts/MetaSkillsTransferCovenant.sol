// SPDX-License-Identifier: MIT
// Contract Name: MetaSkillsTransferCovenant
// Purpose: Encode transfer of meta-skills across contexts (education ↔ work ↔ governance)
// Source: Grounded in Spencer & Lucas 2021 + SDS Progression Framework
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract MetaSkillsTransferCovenant {
    address public chiefOperator;

    struct TransferRecord {
        string skill;        // e.g. Critical Thinking, Adaptability
        string fromContext;  // e.g. Education, Apprenticeship, Governance
        string toContext;    // e.g. Workplace, Policy, Leadership
        string principle;    // e.g. Practice, Reflection, Application
        uint256 timestamp;
    }

    TransferRecord[] public transfers;

    event SkillTransferred(string skill, string fromContext, string toContext, string principle, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    function logTransfer(
        string memory skill,
        string memory fromContext,
        string memory toContext,
        string memory principle
    ) public onlyChief {
        transfers.push(TransferRecord(skill, fromContext, toContext, principle, block.timestamp));
        emit SkillTransferred(skill, fromContext, toContext, principle, block.timestamp);
    }

    function getTransfer(uint256 index) public view returns (
        string memory, string memory, string memory, string memory, uint256
    ) {
        require(index < transfers.length, "Invalid transfer index");
        TransferRecord memory tr = transfers[index];
        return (tr.skill, tr.fromContext, tr.toContext, tr.principle, tr.timestamp);
    }
}
