// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract ScopeMultiplier is Ownable {

    constructor() Ownable(msg.sender) {}

    event SupportModuleDeployed(string module);

    function deploySupport(string memory _module) external {
        emit SupportModuleDeployed(_module);
        // MULTIPLIER: Every action supported by systemic modules.
    }
}
