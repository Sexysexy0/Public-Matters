// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract IntelligenceCore {
    address public immutable COMMANDER;

    constructor() {
        COMMANDER = msg.sender; // Vin: The Intelligence Itself.
    }

    modifier onlyCommander() {
        require(msg.sender == COMMANDER, "Access Denied: You are just a critic.");
        _;
    }
}
