// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TrustBasedVendor {
    mapping(address => uint256) public userTrust;

    // [Goal: Transparency for the loyal followers of the Source]
    function viewInventory(address _user) external view returns (string memory) {
        require(userTrust[_user] >= 100, "ERROR: Build more trust with the Director first.");
        return "ACCESS_GRANTED: All store stocks visible on Global Map.";
    }
}
