// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract DiscountLedger is Ownable {

    constructor() Ownable(msg.sender) {}

    event DiscountSeal(string game, uint256 oldPrice, uint256 newPrice);

    function applyDiscount(string memory _game, uint256 _oldPrice, uint256 _newPrice) external {
        emit DiscountSeal(_game, _oldPrice, _newPrice);
        // RULE: Discount applied to game purchase.
    }
}
