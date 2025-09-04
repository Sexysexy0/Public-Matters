// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../contracts/BudgetOverrideProtocol.sol";

contract BudgetOverrideAudit is Test {
    BudgetOverrideProtocol overrideProtocol;

    function setUp() public {
        overrideProtocol = new BudgetOverrideProtocol();
    }

    function testCommitOverride() public {
        overrideProtocol.commitOverride("Health", 1000000, "Pediatric care restoration");
        (uint256 amount, bool active) = overrideProtocol.getOverride("Health");
        assertEq(amount, 1000000);
        assertTrue(active);
    }

    function testRevokeOverride() public {
        overrideProtocol.commitOverride("Education", 500000, "Scroll-certified teachers");
        overrideProtocol.revokeOverride("Education");
        (, bool active) = overrideProtocol.getOverride("Education");
        assertFalse(active);
    }

    function testMultipleOverrides() public {
        overrideProtocol.commitOverride("Housing", 750000, "Kinder Queen shelters");
        overrideProtocol.commitOverride("Infrastructure", 1200000, "Mythic bridges");
        (uint256 housingAmt, bool housingActive) = overrideProtocol.getOverride("Housing");
        (uint256 infraAmt, bool infraActive) = overrideProtocol.getOverride("Infrastructure");
        assertEq(housingAmt, 750000);
        assertTrue(housingActive);
        assertEq(infraAmt, 1200000);
        assertTrue(infraActive);
    }
}
