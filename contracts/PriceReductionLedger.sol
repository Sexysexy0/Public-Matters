// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract PriceReductionLedger {
    event ReductionSeal(string product, uint256 oldPrice, uint256 newPrice);

    function applyReduction(string memory _product, uint256 _oldPrice) external {
        uint256 newPrice = _oldPrice / 2;
        emit ReductionSeal(_product, _oldPrice, newPrice);
        // RULE: Price reduced by 50% for affordability.
    }
}
