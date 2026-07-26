// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract ArchetypeLedger is Ownable {

    constructor() Ownable(msg.sender) {}

    event ArchetypeChosen(address player, string archetype);

    function chooseArchetype(address _player, string memory _archetype) external {
        emit ArchetypeChosen(_player, _archetype);
        // LEDGER: Player archetype encoded (mage, marksman, swordsman, etc.)
    }
}
