// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract EptoEfficiencyOracle {
    // [12:56-13:27] Supplying battery power to trailer systems
    function calculateFuelSavings(bool _usingEPTO, uint256 _dieselBurnRate) public pure returns (uint256) {
        if (_usingEPTO) {
            // Elimination of separate diesel auxiliary power units (APU)
            return _dieselBurnRate; // 100% savings on auxiliary fuel
        }
        return 0;
    }
}
