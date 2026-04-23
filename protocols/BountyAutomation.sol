// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract BountyAutomation {
    // [Goal: Remove tedious walking in bounty hunting missions]
    function callExtraction(bool _isTiedUp) external pure returns (string memory) {
        if (_isTiedUp) {
            return "SUCCESS: Authorities are picking up the outlaw. Gold reward dispatched.";
        }
        return "ERROR: Secure the target first.";
    }
}
