pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract UserDataShield is Ownable {

    constructor() Ownable(msg.sender) {}

    event DataBreachAlert(string userId, string issue);

    function protectUser(string memory userId, bool unauthorizedAccess) public {
        if (unauthorizedAccess) {
            emit DataBreachAlert(userId, "Unauthorized access detected");
        }
    }
}
