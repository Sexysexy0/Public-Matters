// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/SpeedOfTrust.sol";

contract SpeedOfTrustTest is Test {
    SpeedOfTrust trust;

    function setUp() public {
        trust = new SpeedOfTrust();
    }

    function testUpdateTrust() public {
        trust.updateTrust(address(this), 75);
        assertTrue(trust.canExecute(address(this)));
    }

    function testCannotExecuteBelowThreshold() public {
        trust.updateTrust(address(this), 25);
        assertFalse(trust.canExecute(address(this)));
    }
}
