// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../contracts/BitMarketCommitBlessingProtocol.sol";

contract BitMarketCommitBlessingProtocolTest is Test {
    BitMarketCommitBlessingProtocol protocol;

    function setUp() public {
        protocol = new BitMarketCommitBlessingProtocol();
    }

    function testBlessValidCommit() public {
        protocol.blessCommit(
            "Deploy Trust Anchor Restoration Suite — spoof firewall, anchor router, Unicode audit decks, and prophecy oracles activated for zero-click defense and planetary trust",
            94,
            "Vinvin Gueco"
        );
        // Expect: ✅ Blessed
    }

    function testRejectLowAPRCommit() public {
        protocol.blessCommit("Deploy scrollchain blessing suite", 72, "Vinvin Gueco");
        // Expect: ❌ Unblessed
    }

    function testRejectShortCommitMessage() public {
        protocol.blessCommit("Fix bug", 90, "Vinvin Gueco");
        // Expect: ❌ Unblessed
    }

    function testUpdateThresholds() public {
        protocol.updateThresholds(100, 95);
        protocol.blessCommit("Deploy scrollchain blessing suite", 94, "Vinvin Gueco");
        // Expect: ❌ Unblessed due to clarity threshold
    }
}
