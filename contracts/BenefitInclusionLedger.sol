pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract BenefitInclusionLedger is Ownable {

    constructor() Ownable(msg.sender) {}

    event BenefitAlert(string employer, string issue);

    function checkBenefits(string memory employer, bool complete) public {
        if (!complete) {
            emit BenefitAlert(employer, "Mandatory benefits missing – compliance safeguard required");
        }
    }
}
