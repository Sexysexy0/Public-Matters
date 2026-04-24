// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract EpicCautionaryLogic {
    // [Goal: Stability over unsustainable hyper-growth]
    function checkSustainability(uint256 _growthRate) external pure returns (bool) {
        require(_growthRate < 15, "WARNING: Hyper-growth detected. Pivot to Stability.");
        return true;
    }
}
