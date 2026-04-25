// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract DirectMaterialSourcing {
    // [Goal: Secure bulk materials at factory prices for 100% cost efficiency]
    function purchaseMaterials(string memory _item, uint256 _volume) external pure returns (string memory) {
        return string(abi.encodePacked("ORDERED: ", _item, " volume: ", _volume, ". Shipping direct to Site."));
    }
}
