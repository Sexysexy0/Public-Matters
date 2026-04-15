pragma solidity ^0.8.0;

contract PlatformWorkerRelief {
    function computeAllowance(uint256 hoursWorked) public pure returns (uint256) {
        if (hoursWorked > 12) {
            return 500; // Daily fuel allowance
        }
        return 0;
    }
}
