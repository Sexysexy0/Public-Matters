pragma solidity ^0.8.0;

contract FairSubscriptionProtocol {
    event FairnessAlert(string plan, string issue);

    function checkPlan(string memory plan, bool hiddenFee, bool confusingTerms) public {
        if (hiddenFee || confusingTerms) {
            emit FairnessAlert(plan, "Unethical subscription practice detected");
        }
    }
}
