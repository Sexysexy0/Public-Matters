pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract AITrustProtocol is Ownable {

    constructor() Ownable(msg.sender) {}

    event TrustAlert(string issue);

    function checkTrainingConsent(bool consentGiven) public {
        if (!consentGiven) {
            emit TrustAlert("User content used without consent");
        }
    }
}
