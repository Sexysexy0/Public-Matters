pragma solidity ^0.8.0;

contract EssentialNeedsShield {
    event NeedsAlert(string recipient, string issue);

    function detectShortage(string memory recipient, bool shortage) public {
        if (shortage) {
            emit NeedsAlert(recipient, "Supply shortage detected – safeguard required");
        }
    }
}
