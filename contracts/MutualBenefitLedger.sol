pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract MutualBenefitLedger is Ownable {

    constructor() Ownable(msg.sender) {}

    event BenefitAlert(string partners, string issue);

    function checkBalance(string memory partners, bool balanced) public {
        if (!balanced) {
            emit BenefitAlert(partners, "Imbalance detected – mutual benefit safeguard required");
        }
    }
}
