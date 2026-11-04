// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract AccessControl {
    mapping(address => bool) public guardians;
    uint256 public requiredSignatures = 2;

    event GuardianAdded(address indexed guardian);

    constructor(address[] memory initialGuardians) {
        for (uint i = 0; i < initialGuardians.length; i++) {
            guardians[initialGuardians[i]] = true;
            emit GuardianAdded(initialGuardians[i]);
        }
    }
}
