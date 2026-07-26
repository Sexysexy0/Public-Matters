// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract EarthElement is Ownable {

    constructor() Ownable(msg.sender) {}

    event EarthSeal(address player, string move);

    function castEarth(address _player, string memory _move) external {
        emit EarthSeal(_player, _move);
        // RULE: Earth powers encoded with heavy animations.
    }
}
