pragma solidity ^0.8.0;

contract FoodContinuityShield {
    event ContinuityAlert(string recipient, string issue);

    function detectShortage(string memory recipient, bool shortage) public {
        if (shortage) {
            emit ContinuityAlert(recipient, "Food supply shortage detected – safeguard required");
        }
    }
}
