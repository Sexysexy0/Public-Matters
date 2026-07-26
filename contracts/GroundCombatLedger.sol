// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract GroundCombatLedger is Ownable {

    constructor() Ownable(msg.sender) {}

    event CombatAction(address player, string action);

    function logAction(address _player, string memory _action) external {
        emit CombatAction(_player, _action);
        // RULE: Responsive, kinetic combat preserved.
    }
}
