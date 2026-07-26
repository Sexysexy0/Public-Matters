// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract BlankCanvasHero is Ownable {

    constructor() Ownable(msg.sender) {}

    mapping(address => string[]) public characterTraits;

    // [Goal: Player-Defined Narrative]
    function recordAction(string memory _trait) external {
        // Logic: Build personality through gameplay, not cutscenes.
        characterTraits[msg.sender].push(_trait);
    }
}
