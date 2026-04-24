// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract RefineryStorage {
    uint256 public reserveCapacity;

    // [Goal: Maximize storage duration to survive long-term economic isolation]
    function increaseReserves(uint256 _volume) external {
        reserveCapacity += _volume;
    }
}
