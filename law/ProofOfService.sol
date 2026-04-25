// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ProofOfService {
    // [Goal: Ensure legislative output matches the high salary]
    function verifyContribution(uint256 _billsFiled, uint256 _communityImpact) external pure returns (bool) {
        return (_billsFiled > 0 && _communityImpact > 80);
    }
}
