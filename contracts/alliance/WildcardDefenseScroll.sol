// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.999.0;

contract WildcardDefenseScroll {
    address public defender;
    string public declaration = "We got it";
    bool public activated = false;

    event DefenseActivated(address indexed defender, string declaration);

    function activateDefense() public {
        defender = msg.sender;
        activated = true;
        emit DefenseActivated(defender, declaration);
    }
}
