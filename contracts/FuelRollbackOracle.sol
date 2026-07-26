// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract FuelRollbackOracle is Ownable {

    constructor() Ownable(msg.sender) {}

    uint256 public dieselPriceDrop = 2494; // In cents (P24.94)
    
    // [RELIEF TRACKER] Ensuring the rollback reaches the consumers
    function calculateSavings(uint256 _liters) public view returns (uint256) {
        // Logic: Monitor if gas stations are implementing the P24.94 drop
        return _liters * dieselPriceDrop;
    }
}
