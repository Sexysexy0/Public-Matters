// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CaptainPrivilege {
    address public captain;

    constructor() {
        captain = msg.sender;
    }

    modifier onlyCaptain() {
        require(msg.sender == captain, "NOT THE CAPTAIN: Access Denied.");
        _;
    }

    // [Goal: Emergency manual takeover of all ship systems]
    function emergencyTakeover() external onlyCaptain returns (string memory) {
        return "CAPTAIN ON DECK: Manual controls engaged. AI disabled.";
    }
}
