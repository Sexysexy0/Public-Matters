// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract CombatRhythm is Ownable {

    constructor() Ownable(msg.sender) {}

    // [Goal: Technical Depth over Simple Stats]
    function validateCombo(uint256 _timing) external pure returns (string memory) {
        if (_timing < 100) { // Milliseconds
            return "PERFECT_STRIKE: High impact, zero stamina cost.";
        }
        return "STRIKE: Standard damage.";
    }
}
