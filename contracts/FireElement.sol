// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract FireElement is Ownable {

    constructor() Ownable(msg.sender) {}

    event FireSeal(address player, string move);

    function castFire(address _player, string memory _move) external {
        emit FireSeal(_player, _move);
        // RULE: Fire powers encoded with animations.
    }
}
