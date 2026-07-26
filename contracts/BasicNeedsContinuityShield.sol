pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract BasicNeedsContinuityShield is Ownable {

    constructor() Ownable(msg.sender) {}

    event ContinuityAlert(string recipient, string issue);

    function detectShortage(string memory recipient, bool shortage) public {
        if (shortage) {
            emit ContinuityAlert(recipient, "Supply shortage detected – safeguard required");
        }
    }
}
