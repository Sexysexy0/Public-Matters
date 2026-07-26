pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract MarinerSafetyNet is Ownable {

    constructor() Ownable(msg.sender) {}

    function computeAllowance(uint256 daysAtSea) public pure returns (uint256) {
        if (daysAtSea > 180) {
            return 1200; // Long voyage welfare credit
        }
        return 0;
    }
}
