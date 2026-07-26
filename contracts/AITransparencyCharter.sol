pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract AITransparencyCharter is Ownable {

    constructor() Ownable(msg.sender) {}

    event TransparencyViolation(string issue);

    function checkConsent(bool consentGiven) public {
        if (!consentGiven) {
            emit TransparencyViolation("User content used without consent");
        }
    }
}
