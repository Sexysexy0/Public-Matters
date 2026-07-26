// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract PriceAdjustmentLedger {
    event AdjustmentSeal(string tier, uint256 oldPrice, uint256 newPrice);

    function logAdjustment(string memory _tier, uint256 _oldPrice, uint256 _newPrice) external {
        emit AdjustmentSeal(_tier, _oldPrice, _newPrice);
        // LEDGER: Price rollback encoded for consumer relief.
    }
}
