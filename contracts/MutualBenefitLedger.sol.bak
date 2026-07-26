pragma solidity ^0.8.0;

contract MutualBenefitLedger {
    event BenefitAlert(string partners, string issue);

    function checkBalance(string memory partners, bool balanced) public {
        if (!balanced) {
            emit BenefitAlert(partners, "Imbalance detected – mutual benefit safeguard required");
        }
    }
}
