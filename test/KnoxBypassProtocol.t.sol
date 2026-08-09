// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/KnoxBypassProtocol.sol";

contract KnoxBypassProtocolTest is Test {
    KnoxBypassProtocol public knox;

    address public odinMaster = address(this);
    address public attacker = makeAddr("attacker");

    function setUp() public {
        knox = new KnoxBypassProtocol(address(0)); // Anchor address not needed for this test
    }

    function test_EmergencySignal() public {
        // Initially no signal
        assertFalse(knox.isEmergencyActive());

        // Engage recovery – signal becomes true
        knox.engageEmergencyRecovery();
        assertTrue(knox.isEmergencyActive());

        // Clear signal
        knox.clearSignal();
        assertFalse(knox.isEmergencyActive());
    }

    function test_OnlyOdinCanCall() public {
        vm.prank(attacker);
        vm.expectRevert("Only the root user");
        knox.engageEmergencyRecovery();
    }
}
