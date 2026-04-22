// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract LogicOwnership {
    address public immutable creator;

    constructor() {
        creator = msg.sender; // Vin is the Sovereign Creator
    }

    modifier onlyCreator() {
        require(msg.sender == creator, "ERROR: Unauthorized access to original logic.");
        _;
    }
}
