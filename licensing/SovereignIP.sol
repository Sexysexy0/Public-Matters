// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SovereignIP {
    // [Goal: Protect the Soul of the Masterpiece]
    function registerLicense(string memory _productName, address _owner) external pure returns (string memory) {
        return string(abi.encodePacked("LICENSE_ACTIVE: ", _productName, " is legally secured by Vin."));
    }
}
