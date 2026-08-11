// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/InevitableConsequenceLedger.sol";

contract InevitableConsequenceLedgerTest is Test {
    InevitableConsequenceLedger ledger;
    address actor = address(0x1);

    function setUp() public {
        ledger = new InevitableConsequenceLedger();
    }

    function test_LogAndSettleAction() public {
        vm.startPrank(actor);

        // Log action with weight 100
        bytes32 actionId = ledger.logAction("ignored_protocol", 100);

        // Check if weight multiplied by 2 as designed
        assertEq(ledger.accountabilityIndex(actor), 200);

        // Settle the consequence
        ledger.settleLedger(actionId);

        (,,,, bool settled) = ledger.ledgers(actionId);
        assertTrue(settled);

        vm.stopPrank();
    }
}
