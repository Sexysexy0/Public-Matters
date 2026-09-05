// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/DiplomaticNuance.sol";

contract DiplomaticNuanceTest is Test {
    DiplomaticNuance nuance;

    function setUp() public {
        nuance = new DiplomaticNuance();
    }

    function testRegisterAlly() public {
        nuance.registerAlly(address(0xBEEF), "Shared security interests");
        (address allyAddr, string memory interests) = nuance.allies(address(0xBEEF));
        assertEq(allyAddr, address(0xBEEF));
        assertEq(interests, "Shared security interests");
    }
}
