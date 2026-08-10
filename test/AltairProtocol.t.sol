// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/AltairProtocol.sol";

contract AltairProtocolTest is Test {
    AltairProtocol altair;
    address candidate = address(0x1337);

    function setUp() public {
        altair = new AltairProtocol();
    }

    function test_DisciplineAndLock() public {
        altair.discipline(candidate);
        assertTrue(altair.certifiedBrothers(candidate));
        assertEq(altair.disciplineIndex(candidate), 100);

        altair.lockCodex();
        assertTrue(altair.codexLocked());
    }

    function test_RevertWhenLocked() public {
        altair.lockCodex();
        vm.expectRevert("Codex is locked. No changes allowed.");
        altair.discipline(candidate);
    }
}
