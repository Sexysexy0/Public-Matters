// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ArchetypeLedger {
    event ArchetypeChosen(address player, string archetype);

    function chooseArchetype(address _player, string memory _archetype) external {
        emit ArchetypeChosen(_player, _archetype);
        // LEDGER: Player archetype encoded (mage, marksman, swordsman, etc.)
    }
}
