// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract DyeSystem {
    // [Goal: Customize the 'Colors' of your professional output without changing the core engine]
    function applyDye(string memory _module, string memory _hexColor) external pure returns (string memory) {
        return string(abi.encodePacked("DYE_APPLIED: Module ", _module, " is now branded with ", _hexColor));
    }
}
