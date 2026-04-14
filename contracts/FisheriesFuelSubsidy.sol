// FisheriesFuelSubsidy.sol
// Logic: Shielding the Fleet from Oil Price Volatility
pragma solidity ^0.8.0;

contract FisheriesFuelSubsidy {
    uint256 public constant OIL_CRISIS_PRICE = 90; // Price per liter threshold

    function calculateSubsidy(uint256 _currentPrice) public pure returns (uint256) {
        // Goal: Ensure fishing remains profitable.
        // If oil is too expensive, the Sovereign Fund covers the 30% gap.
        if (_currentPrice >= OIL_CRISIS_PRICE) {
            return (_currentPrice * 30) / 100;
        }
        return 0;
    }
}
