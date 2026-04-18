// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract StepUpBasisEraser {
    // [0:38:18] Preventing the "Angel of Death" loophole
    function calculateTrueGain(uint256 _originalBuyPrice, uint256 _currentValue) public pure returns (uint256) {
        // Ang buwis ay base sa orihinal na puhunan, hindi sa halaga nung namatay ang may-ari.
        return _currentValue - _originalBuyPrice; 
    }
}
