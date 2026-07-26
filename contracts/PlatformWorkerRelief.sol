pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract PlatformWorkerRelief is Ownable {

    constructor() Ownable(msg.sender) {}

    function computeAllowance(uint256 hoursWorked) public pure returns (uint256) {
        if (hoursWorked > 12) {
            return 500; // Daily fuel allowance
        }
        return 0;
    }
}
