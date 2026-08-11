// SPDX-License-Identifier: MIT
pragma solidity 0.8.35;

import "forge-std/Test.sol";
import "../src/MorrisResilienceProtocol.sol";

contract MorrisResilienceProtocolTest is Test {
    MorrisResilienceProtocol protocol;
    address steward = address(0x1);
    address rogueNode = address(0x2);
    address normalNode = address(0x3);

    function setUp() public {
        protocol = new MorrisResilienceProtocol(steward);
    }

    function test_NormalOperationAndThreshold() public {
        // Mag-simulate ng normal requests na hindi aabot sa threshold (5)
        for (uint256 i = 0; i < 5; i++) {
            protocol.monitorAndVerifyNode(normalNode);
        }
        
        assertFalse(protocol.systemLocked());
        assertEq(protocol.nodeRequestCounts(normalNode), 5);
    }

    function test_CircuitBreakerTriggersOnRapidReplication() public {
        // Unang 5 na tawag (papasok sa threshold)
        for (uint256 i = 0; i < 5; i++) {
            protocol.monitorAndVerifyNode(rogueNode);
        }
        assertFalse(protocol.systemLocked());

        // Ika-6 na tawag (dapat mag-trigger ang circuit breaker at mag-lock ang sistema)
        protocol.monitorAndVerifyNode(rogueNode);

        assertTrue(protocol.systemLocked());
        assertTrue(protocol.blacklistedNodes(rogueNode));
    }

    function test_StewardCanResumeSystem() public {
        // I-trigger ang lockdown gamit ang rogue node
        for (uint256 i = 0; i < 6; i++) {
            protocol.monitorAndVerifyNode(rogueNode);
        }
        assertTrue(protocol.systemLocked());

        // Dapat hindi makapag-monitor ang ibang node habang naka-lock
        vm.expectRevert("System is under emergency lockdown due to worm-like propagation");
        protocol.monitorAndVerifyNode(normalNode);

        // Si steward lang ang pwedeng mag-resibo at mag-unlock
        vm.prank(steward);
        protocol.resumeSystem();

        assertFalse(protocol.systemLocked());
    }
}
