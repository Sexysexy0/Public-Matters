pragma solidity ^0.8.0;

contract MarinerWelfareShield {
    function computeAllowance(uint256 daysAtSea) public pure returns (uint256) {
        if (daysAtSea > 180) {
            return 1000; // Long voyage welfare credit
        }
        return 0;
    }
}
