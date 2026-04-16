pragma solidity ^0.8.0;

contract AITrustProtocol {
    event TrustAlert(string issue);

    function checkTrainingConsent(bool consentGiven) public {
        if (!consentGiven) {
            emit TrustAlert("User content used without consent");
        }
    }
}
