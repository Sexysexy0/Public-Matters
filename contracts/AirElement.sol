// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract AirElement is Ownable {

    constructor() Ownable(msg.sender) {}

    event AirSeal(address player, string move);

    function castAir(address _player, string memory _move) external {
        emit AirSeal(_player, _move);
        // RULE: Air powers encoded with dynamic animations.
    }
}
