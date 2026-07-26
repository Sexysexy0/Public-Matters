// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract CombatRootsLedger is Ownable {

    constructor() Ownable(msg.sender) {}

    event CombatSeal(string game, string status);

    function logCombat(string memory _game, string memory _status) external {
        emit CombatSeal(_game, _status);
        // RULE: Preserve classic chain-takedown combat roots.
    }
}
