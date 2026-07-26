// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract BundleLogic is Ownable {

    constructor() Ownable(msg.sender) {}

    // [Goal: Encourage Multi-game Ownership]
    function calculateTotal(uint256 _gameCount, uint256 _basePrice) public pure returns (uint256) {
        if (_gameCount >= 2) {
            // Action: Apply 20% discount para "magaan sa bulsa."
            return (_basePrice * _gameCount * 80) / 100;
        }
        return _basePrice * _gameCount;
    }
}
