pragma solidity ^0.8.0;

contract UserDataShield {
    event DataBreachAlert(string userId, string issue);

    function protectUser(string memory userId, bool unauthorizedAccess) public {
        if (unauthorizedAccess) {
            emit DataBreachAlert(userId, "Unauthorized access detected");
        }
    }
}
