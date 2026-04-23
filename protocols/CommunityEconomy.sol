// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CommunityEconomy {
    // [Goal: Facilitate a balanced, player-driven marketplace]
    function listAsset(string memory _itemName, uint256 _price) external pure returns (string memory) {
        if (_price > 1000000) return "REJECTED: Price exceeding market cap.";
        return string(abi.encodePacked("LISTED: ", _itemName, " is now on the Tortuga Market."));
    }
}
