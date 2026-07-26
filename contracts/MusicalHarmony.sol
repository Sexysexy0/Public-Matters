// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract MusicalHarmony is Ownable {

    constructor() Ownable(msg.sender) {}

    // [Goal: Harmonize the Soul with the Code]
    function playInstrument(string memory _instrument) external pure returns (string memory) {
        // Logic: Music reduces system stress and improves user retention.
        return string(abi.encodePacked("MUSIC_ACTIVE: Playing the ", _instrument, ". Buffing morale."));
    }
}
