// SPDX-License-Identifier: MIT
// Contract Name: MetaSkillsTraining
// Purpose: Governance OS training covenant for meta-skills
pragma solidity ^0.8.20;

contract MetaSkillsTraining {
    address public chiefOperator;

    struct TrainingModule {
        string moduleName;
        string objective;
        string covenantLink;
        uint256 timestamp;
    }

    TrainingModule[] public modules;

    event ModuleDeployed(string moduleName, string objective, string covenantLink, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    function deployModule(string memory moduleName, string memory objective, string memory covenantLink) public onlyChief {
        modules.push(TrainingModule(moduleName, objective, covenantLink, block.timestamp));
        emit ModuleDeployed(moduleName, objective, covenantLink, block.timestamp);
    }

    function getModule(uint256 index) public view returns (string memory, string memory, string memory, uint256) {
        require(index < modules.length, "Invalid module index");
        TrainingModule memory m = modules[index];
        return (m.moduleName, m.objective, m.covenantLink, m.timestamp);
    }
}
