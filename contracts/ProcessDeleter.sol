// ProcessDeleter.sol
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract ProcessDeleter is Ownable {

    constructor() Ownable(msg.sender) {}

    // If you are not adding things back 10% of the time, 
    // you are not deleting enough. [0:20]
    function deleteProcess(string memory _stepID) public {
        // Logic: Deletes the step entirely. 
        // Example: The "Glass Mats" that served no purpose [3:40]
    }
}
