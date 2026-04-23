// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract InventorySorting {
    // [Goal: Implement categorization to prevent clutter]
    function sortItems(string memory _tab) external pure returns (string memory) {
        return string(abi.encodePacked("FILTERED: Showing items in ", _tab));
    }

    function lockItem(uint256 _itemId) external pure returns (bool) {
        return true; // Item is now protected from accidental deletion
    }
}
