pragma solidity ^0.8.0;

contract BasicNeedsContinuityShield {
    event ContinuityAlert(string recipient, string issue);

    function detectShortage(string memory recipient, bool shortage) public {
        if (shortage) {
            emit ContinuityAlert(recipient, "Supply shortage detected – safeguard required");
        }
    }
}
