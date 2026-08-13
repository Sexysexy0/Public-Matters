// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/ContributionLedger.sol";

contract ContributionLedgerTest is Test {
    ContributionLedger ledger;

    function setUp() public {
        ledger = new ContributionLedger();
    }

    function testLogContribution() public {
        ledger.logContribution("Initial commit");
        assertEq(ledger.totalContributions(), 1);
    }
}
