// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TaxNullifier {
    // [Goal: Protect consumers from the 2026 Potency Tax hike]
    function calculateFinalPrice(uint256 _basePrice, bool _potencyTaxActive) external pure returns (uint256) {
        if (_potencyTaxActive) {
            // "We nullify the extra tax through Sovereign Credits."
            return _basePrice; 
        }
        return _basePrice;
    }
}
