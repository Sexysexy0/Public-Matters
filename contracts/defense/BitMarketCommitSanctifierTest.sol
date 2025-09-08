// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../contracts/BitMarketCommitSanctifier.sol";

contract BitMarketCommitSanctifierTest is Test {
    BitMarketCommitSanctifier sanctifier;

    function setUp() public {
        sanctifier = new BitMarketCommitSanctifier();
    }

    function testValidCommitMessage() public {
        bool result = sanctifier.validateCommitMessage("Deploy Trust Anchor Restoration Suite — spoof firewall, anchor router, Unicode audit decks, and prophecy oracles activated for zero-click defense and planetary trust");
        assertTrue(result);
    }

    function testShortCommitMessageFails() public {
        bool result = sanctifier.validateCommitMessage("Fix bug");
        assertFalse(result);
    }

    function testThresholdUpdate() public {
        sanctifier.updateThreshold(100);
        bool result = sanctifier.validateCommitMessage("Deploy scrollchain blessing suite");
        assertFalse(result);
    }
}
