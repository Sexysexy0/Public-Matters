// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MarketplaceBridge {
    event PurchaseRecord(address user, string game, uint256 price);

    function logPurchase(address _user, string memory _game, uint256 _price) external {
        emit PurchaseRecord(_user, _game, _price);
        // BRIDGE: Hybrid subscription + discounted purchase encoded.
    }
}
