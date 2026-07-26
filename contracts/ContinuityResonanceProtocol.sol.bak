// ContinuityResonanceProtocol.sol
pragma solidity ^0.8.0;

contract ContinuityResonanceProtocol {
    struct Plan {
        uint256 id;
        string domain;    // e.g. "Business Operations"
        string measure;   // e.g. "Disaster recovery plan"
        string outcome;   // e.g. "Operational"
        uint256 timestamp;
    }

    uint256 public planCount;
    mapping(uint256 => Plan) public plans;

    event PlanLogged(uint256 id, string domain, string measure, string outcome);

    function logPlan(string memory domain, string memory measure, string memory outcome) public {
        planCount++;
        plans[planCount] = Plan(planCount, domain, measure, outcome, block.timestamp);
        emit PlanLogged(planCount, domain, measure, outcome);
    }
}
