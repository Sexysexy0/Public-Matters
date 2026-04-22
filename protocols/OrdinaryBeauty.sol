// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract OrdinaryBeauty {
    // [Goal: Reject the Boring and the Generic]
    function validateDesign(bool _isGeneric) external pure returns (string memory) {
        if (_isGeneric) {
            return "ERROR: Society has lost its belief. Redesign for beauty.";
        }
        return "SUCCESS: Joy of Noticing activated.";
    }
}
