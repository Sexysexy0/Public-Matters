pragma solidity ^0.8.0;

contract SubscriptionTransparency {
    event PlanDisclosure(string plan, string terms);

    function disclosePlan(string memory plan, string memory terms) public {
        emit PlanDisclosure(plan, terms);
    }
}
