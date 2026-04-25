// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract DiscountAccessBridge {
    event DiscountRecord(address user, string game, uint256 price);

    function grantDiscount(address _user, string memory _game, uint256 _price) external {
        emit DiscountRecord(_user, _game, _price);
        // BRIDGE: Discounted game purchase alongside subscription.
    }
}
