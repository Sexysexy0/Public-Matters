// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract OutrageFilterProtocol {
    // Detects high-emotional/low-fact content to prevent "Mirror of Radicalisation" [3:36]
    function deEscalateDiscourse(uint256 _outrageLevel) public pure returns (bool) {
        if (_outrageLevel > 90) {
            return false; // Force cooling-down period for better debate
        }
        return true;
    }
}
