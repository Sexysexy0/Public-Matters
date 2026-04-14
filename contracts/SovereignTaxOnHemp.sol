// SovereignTaxOnHemp.sol
// Logic: Wealth Redistribution to Farmers
pragma solidity ^0.8.0;

contract SovereignTaxOnHemp {
    function calculateTax(uint256 _marketPrice) public pure returns (uint256) {
        // Goal: Sustainable Revenue.
        // 10% Sovereign Tax to be reinvested in local irrigation and tech.
        return (_marketPrice * 10) / 100;
    }
}
