// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract InvisibleDiscipline is Ownable {

    constructor() Ownable(msg.sender) {}

    // [36:03] Practice is humble and private
    function logCharacterGrowth(bool _postedOnSocialMedia) public pure returns (bool) {
        if (_postedOnSocialMedia) {
            // "If you perform it, you are protecting your ego, not building virtue."
            return false; 
        }
        return true; // Authentic internal development
    }
}
