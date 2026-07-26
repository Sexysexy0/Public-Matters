pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract EssentialNeedsShield is Ownable {

    constructor() Ownable(msg.sender) {}

    event NeedsAlert(string recipient, string issue);

    function detectShortage(string memory recipient, bool shortage) public {
        if (shortage) {
            emit NeedsAlert(recipient, "Supply shortage detected – safeguard required");
        }
    }
}
