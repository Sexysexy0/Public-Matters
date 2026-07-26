pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract BasicNeedsShield is Ownable {

    constructor() Ownable(msg.sender) {}

    event NeedsAlert(string union, string issue);

    function detectShortage(string memory union, bool shortage) public {
        if (shortage) {
            emit NeedsAlert(union, "Shortage detected – safeguard required");
        }
    }
}
