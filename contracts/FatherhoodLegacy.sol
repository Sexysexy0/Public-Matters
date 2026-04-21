// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract FatherhoodLegacy {
    mapping(address => uint256) public inheritance;

    // [Goal: Protecting the Offspring]
    function secureAsset(address _child, uint256 _value) external {
        inheritance[_child] += _value;
        // Action: Immutable protection for the next generation.
    }
}
