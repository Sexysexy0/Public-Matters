pragma solidity ^0.8.0;

contract AITransparencyCharter {
    event TransparencyViolation(string issue);

    function checkConsent(bool consentGiven) public {
        if (!consentGiven) {
            emit TransparencyViolation("User content used without consent");
        }
    }
}
