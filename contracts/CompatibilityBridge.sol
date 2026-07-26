// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract CompatibilityBridge is Ownable {

    constructor() Ownable(msg.sender) {}

    event CompatibilityRecord(string modName, string range);

    function logCompatibility(string memory modName, string memory range) external {
        emit CompatibilityRecord(modName, range);
        // BRIDGE: Compatibility ranges logged to safeguard mod stability across updates.
    }
}
