// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ADBGrantSync {
    // [Goal: Secure the $1M funding for the Semirara Urea Plant]
    uint256 public constant grantAmount = 1000000; // USD

    function allocateFunds(string memory _phase) external pure returns (string memory) {
        return string(abi.encodePacked("FUNDS_ALLOCATED: ", _phase, " - Feasibility Study on track for Sept 2026."));
    }
}
