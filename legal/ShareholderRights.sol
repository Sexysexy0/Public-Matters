// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ShareholderRights {
    // [Goal: Protect the Majority interest against management mismanagement]
    function exerciseVeto(uint256 _sharePercentage) external pure returns (string memory) {
        require(_sharePercentage > 50, "ERROR: Insufficient control.");
        return "ACTION: Management removal sequence authorized by the Majority.";
    }
}

