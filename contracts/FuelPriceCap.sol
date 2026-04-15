pragma solidity ^0.8.0;

contract FuelPriceCap {
    uint256 constant MAX_PRICE = 70; // ₱70/liter cap

    function enforceCap(uint256 _price) public pure returns (uint256) {
        if (_price > MAX_PRICE) {
            return MAX_PRICE; // Subsidy kicks in
        }
        return _price;
    }
}
