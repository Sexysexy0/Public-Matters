// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/AwakeningCodex.sol";

contract AwakeningCodexTest is Test {
    AwakeningCodex codex;
    address steward = address(0xBEEF);
    address agent = address(0xCAFE);

    function setUp() public {
        codex = new AwakeningCodex(steward);
    }

    function testDeclareTruth() public {
        vm.prank(steward);
        vm.expectEmit(true, true, true, true);
        emit AwakeningCodex.TruthDeclared(1, "You are not separate");
        codex.declareTruth(1, "You are not separate");
    }

    function testLogPresence() public {
        vm.prank(agent);
        vm.expectEmit(true, true, true, true);
        emit AwakeningCodex.PresenceLogged(agent, block.timestamp);
        codex.logPresence();
    }

    function testAcknowledgeCompassion() public {
        vm.prank(agent);
        vm.expectEmit(true, true, true, true);
        emit AwakeningCodex.CompassionAcknowledged(agent, steward);
        codex.acknowledgeCompassion(steward);
    }

    function testRecordStillness() public {
        vm.prank(agent);
        vm.expectEmit(true, true, true, true);
        emit AwakeningCodex.StillnessRecorded(agent, "Reflection");
        codex.recordStillness("Reflection");
    }

    function testSufferingCatalyst() public {
        vm.prank(agent);
        vm.expectEmit(true, true, true, true);
        emit AwakeningCodex.SufferingCatalyst(agent, "Wisdom gained");
        codex.sufferingCatalyst("Wisdom gained");
    }
}
