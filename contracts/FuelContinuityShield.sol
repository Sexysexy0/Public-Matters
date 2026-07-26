pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract FuelContinuityShield is Ownable {

    constructor() Ownable(msg.sender) {}

    event ContinuityAlert(string recipient, string issue);

    function detectIssue(string memory recipient, bool issueDetected) public {
        if (issueDetected) {
            emit ContinuityAlert(recipient, "Fuel coupon safeguard required – continuity support activated");
        }
    }
}
