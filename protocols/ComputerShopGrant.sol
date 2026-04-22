// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ComputerShopGrant {
    // [Goal: Distribute high-end hardware to the grassroots level]
    function donateToShop(string memory _shopName, uint256 _gpuCount) external pure returns (string memory) {
        return string(abi.encodePacked("GRANT_APPROVED: ", _gpuCount, " RTX 5090s sent to ", _shopName));
    }
}
