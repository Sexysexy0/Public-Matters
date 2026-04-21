// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract GiftingProtocol {
    // [Goal: Expand the Community Organically]
    function giftBundlePrice(uint256 _price) external pure returns (uint256) {
        // Action: 25% off for gift-pairs.
        return (_price * 2 * 75) / 100;
    }
}
