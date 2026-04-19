// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ExciseTaxSuspender {
    // [2:21-4:02] Suspend excise taxes during supply shocks
    function checkTaxExemption(uint256 _globalOilPrice) public pure returns (string memory) {
        if (_globalOilPrice > 100) { // Example threshold: $100/barrel
            return "SIGNAL: SUSPEND EXCISE TAX. Prioritize household budget over government revenue.";
        }
        return "SIGNAL: Standard Tax Active.";
    }
}
