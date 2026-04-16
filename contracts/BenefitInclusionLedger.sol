pragma solidity ^0.8.0;

contract BenefitInclusionLedger {
    event BenefitAlert(string employer, string issue);

    function checkBenefits(string memory employer, bool complete) public {
        if (!complete) {
            emit BenefitAlert(employer, "Mandatory benefits missing – compliance safeguard required");
        }
    }
}
