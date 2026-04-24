// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MinimalistGovernance {
    // [Goal: Tools for survival, not for vanity]
    function allocateResource(uint256 _utilityScore) external pure returns (string memory) {
        require(_utilityScore > 80, "DENIED: Resource is vanity, not a tool.");
        return "APPROVED: Essential tool for Sovereign survival.";
    }
}
