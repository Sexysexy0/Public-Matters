// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract ExplorationTelescopeShield is Ownable {

    constructor() Ownable(msg.sender) {}

    event DiscoverySeal(address player, string location, string status);

    function logDiscovery(address player, string memory location) external {
        emit DiscoverySeal(player, location, "Telescope Used");
        // RULE: Telescope safeguarded as exploration tool for immersion.
    }
}
