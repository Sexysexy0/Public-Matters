// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../contracts/DueProcessCodex.sol";
import "../contracts/SammaCodex.sol";

contract TestSuite is Test {
    DueProcessCodex public dueProcess;
    SammaCodex public samma;

    function setUp() public {
        dueProcess = new DueProcessCodex();
        samma = new SammaCodex(address(this));
    }

    function testRejectPhantomAccusation() public {
        vm.expectRevert("Invalid accusation");
        dueProcess.fileAccusation(address(0), "Accusation details long enough to pass length check");
    }

    function testRejectSelfAccusation() public {
        vm.expectRevert("Cannot accuse self");
        dueProcess.fileAccusation(address(this), "Accusation details long enough to pass length check");
    }

    function testPrincipleDeclaration() public {
        samma.declarePrinciple("No Extortion", "Accusations must be transparent and detailed");
        assertTrue(samma.isActive(1));
    }
}
