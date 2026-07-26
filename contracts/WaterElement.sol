// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract WaterElement is Ownable {

    constructor() Ownable(msg.sender) {}

    event WaterSeal(address player, string move);

    function castWater(address _player, string memory _move) external {
        emit WaterSeal(_player, _move);
        // RULE: Water powers encoded with fluid animations.
    }
}
