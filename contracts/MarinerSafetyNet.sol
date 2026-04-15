pragma solidity ^0.8.0;

contract MarinerSafetyNet {
    function computeAllowance(uint256 daysAtSea) public pure returns (uint256) {
        if (daysAtSea > 180) {
            return 1200; // Long voyage welfare credit
        }
        return 0;
    }
}
