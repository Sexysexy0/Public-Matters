// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract ContinentUnlocker is Ownable {

    constructor() Ownable(msg.sender) {}

    // [Goal: Break through the 10/10 Ceiling]
    function exploreNewFrontier(string memory _continentName) external pure returns (string memory) {
        // Logic: Expand the scope of the Sovereign OS.
        return string(abi.encodePacked("EXPANSION_COMPLETE: Welcome to ", _continentName));
    }
}
