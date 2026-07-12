// SPDX-License-Identifier: MIT
// Contract Name: MetaSkillsEvaluationCovenant
// Purpose: Multi-method evaluation covenant for meta-skills (employer, educator, learner perspectives)
// Source: Grounded in Spencer & Lucas 2021 + SDS Progression Framework
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract MetaSkillsEvaluationCovenant {
    address public chiefOperator;

    struct Evaluation {
        string skill;       // e.g. Integrity, Adapting, Communicating
        string perspective; // employer, educator, learner
        string method;      // e.g. observation, reflection journal, peer feedback
        string result;      // qualitative/quantitative outcome
        uint256 timestamp;
    }

    Evaluation[] public evaluations;

    event EvaluationLogged(string skill, string perspective, string method, string result, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    function logEvaluation(
        string memory skill,
        string memory perspective,
        string memory method,
        string memory result
    ) public onlyChief {
        evaluations.push(Evaluation(skill, perspective, method, result, block.timestamp));
        emit EvaluationLogged(skill, perspective, method, result, block.timestamp);
    }

    function getEvaluation(uint256 index) public view returns (
        string memory, string memory, string memory, string memory, uint256
    ) {
        require(index < evaluations.length, "Invalid evaluation index");
        Evaluation memory e = evaluations[index];
        return (e.skill, e.perspective, e.method, e.result, e.timestamp);
    }
}
