// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../contracts/DueProcessCodex.sol";
import "../contracts/DamayStateMachine.sol";
import "../contracts/EmotionalAPR.sol";
import "../contracts/SammaCodex.sol";
import "../contracts/CivicDAO.sol";
import "../contracts/ValidatorRegistry.sol";

contract TestSuite is Test {
    DueProcessCodex dueProcess;
    DamayStateMachine damay;
    EmotionalAPR apr;
    SammaCodex samma;
    CivicDAO civic;
    ValidatorRegistry registry;

    function setUp() public {
        dueProcess = new DueProcessCodex();
        damay = new DamayStateMachine();
        apr = new EmotionalAPR(address(damay));
        samma = new SammaCodex(address(this));
        civic = new CivicDAO(address(samma));
        registry = new ValidatorRegistry();
    }

    function testRejectPhantomAccusation() public {
        vm.expectRevert();
        dueProcess.fileAccusation(address(0), ""); // too vague, should fail
    }

    function testAPRTriggersDamay() public {
        apr.updateAPR(-100, 0, 0, 0, address(this)); // CPI shock lowers APR
        assertEq(uint(damay.exchanges(address(this)).phase), uint(DamayStateMachine.DamayPhase.Alert));
    }

    function testPrincipleDeclaration() public {
        samma.declarePrinciple("No Extortion", "Accusations must be transparent and detailed");
        assertTrue(samma.isActive(1));
    }
}
