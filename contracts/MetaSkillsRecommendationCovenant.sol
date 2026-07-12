// SPDX-License-Identifier: MIT
// Contract Name: MetaSkillsRecommendationCovenant
// Purpose: Encode policy recommendations + commissioning new materials for meta-skills
// Source: Grounded in Spencer & Lucas 2021 (recommendations: guidance, new materials, empirical testing, long-term evaluation)
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract MetaSkillsRecommendationCovenant {
    address public chiefOperator;

    struct Recommendation {
        string category;   // e.g. Guidance, Materials, Employer Testing, Evaluation
        string detail;     // e.g. Provide clear definitions, Commission training modules
        string stakeholder; // e.g. Employer, Educator, Policy-maker
        uint256 timestamp;
    }

    Recommendation[] public recommendations;

    event RecommendationLogged(string category, string detail, string stakeholder, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    function logRecommendation(
        string memory category,
        string memory detail,
        string memory stakeholder
    ) public onlyChief {
        recommendations.push(Recommendation(category, detail, stakeholder, block.timestamp));
        emit RecommendationLogged(category, detail, stakeholder, block.timestamp);
    }

    function getRecommendation(uint256 index) public view returns (
        string memory, string memory, string memory, uint256
    ) {
        require(index < recommendations.length, "Invalid recommendation index");
        Recommendation memory r = recommendations[index];
        return (r.category, r.detail, r.stakeholder, r.timestamp);
    }
}
