// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract PrototypeAnimation is Ownable {

    constructor() Ownable(msg.sender) {}

    event AnimationSeal(string archetype, string animation);

    function addAnimation(string memory _archetype, string memory _animation) external {
        emit AnimationSeal(_archetype, _animation);
        // PROTOTYPE: New combat animations linked to archetypes.
    }
}
