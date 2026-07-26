// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract AntiPerformanceGuard is Ownable {

    constructor() Ownable(msg.sender) {}

    // [22:30] Practice is private and humble
    function validateDiscipline(bool _isForSocialMedia) public pure returns (bool) {
        if (_isForSocialMedia) {
            // "When performance starts, Stoicism ends."
            return false; 
        }
        return true; // Valid character development
    }
}
