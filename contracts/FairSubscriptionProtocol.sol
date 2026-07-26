pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract FairSubscriptionProtocol is Ownable {

    constructor() Ownable(msg.sender) {}

    event FairnessAlert(string plan, string issue);

    function checkPlan(string memory plan, bool hiddenFee, bool confusingTerms) public {
        if (hiddenFee || confusingTerms) {
            emit FairnessAlert(plan, "Unethical subscription practice detected");
        }
    }
}
