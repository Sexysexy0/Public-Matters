// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract AntiSanitizationProtocol is Ownable {

    constructor() Ownable(msg.sender) {}

    string public originalManifesto;
    bool public isLocked = true;

    // [Goal: Protect Art from 'Safe-Space' Filters]
    function viewOriginalContent() public view returns (string memory) {
        // Returns the raw, unedited version. 
        // No "sensitivity patches" allowed.
        return originalManifesto;
    }
}
