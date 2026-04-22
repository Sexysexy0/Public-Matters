// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract FinishedProductAudit {
    // [Goal: Ensure the build pays for its own legacy]
    function checkROI(uint256 _revenue, uint256 _devCost) external pure returns (string memory) {
        if (_revenue > _devCost) {
            return "VOTED_WITH_WALLET: The market recognizes the Architect.";
        }
        return "RESTRUCTURE: System needs more value.";
    }
}
