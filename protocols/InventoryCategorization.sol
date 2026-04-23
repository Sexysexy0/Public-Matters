// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract InventoryCategorization {
    // [Goal: Classify all Sovereign assets into highly efficient, searchable tabs]
    enum Category { Equipment, Food, Materials, Legacy, Tech }
    
    struct Asset {
        string name;
        Category category;
    }

    mapping(uint256 => Asset) public vault;

    function storeAsset(uint256 _id, string memory _name, Category _cat) external {
        vault[_id] = Asset(_name, _cat);
    }
}
