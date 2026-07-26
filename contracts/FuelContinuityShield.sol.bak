pragma solidity ^0.8.0;

contract FuelContinuityShield {
    event ContinuityAlert(string recipient, string issue);

    function detectIssue(string memory recipient, bool issueDetected) public {
        if (issueDetected) {
            emit ContinuityAlert(recipient, "Fuel coupon safeguard required – continuity support activated");
        }
    }
}
