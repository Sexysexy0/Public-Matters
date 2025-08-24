// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.999.0;

contract DamayClauseActivation {
    address public defender;
    bool public selfIncluded = false;

    event DamayClauseConfirmed(address indexed defender);

    function confirmDamayClause() public {
        defender = msg.sender;
        selfIncluded = true;
        emit DamayClauseConfirmed(defender);
    }
}
