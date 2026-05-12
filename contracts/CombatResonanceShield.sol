// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CombatResonanceShield {
    struct CombatUpdate {
        address player;
        string character;
        string skill;
        uint256 timestamp;
        bool balanced;
    }

    CombatUpdate[] public updates;

    event CombatLogged(address indexed player, string character, string skill);
    event CombatBalanced(uint256 indexed id, address verifier);

    function logCombat(string memory _character, string memory _skill) public {
        updates.push(CombatUpdate(msg.sender, _character, _skill, block.timestamp, false));
        emit CombatLogged(msg.sender, _character, _skill);
    }

    function balanceCombat(uint256 _id) public {
        require(_id < updates.length, "Invalid ID");
        updates[_id].balanced = true;
        emit CombatBalanced(_id, msg.sender);
    }

    function getCombat(uint256 _id) public view returns (CombatUpdate memory) {
        require(_id < updates.length, "Invalid ID");
        return updates[_id];
    }

    function totalCombatUpdates() public view returns (uint256) {
        return updates.length;
    }
}
