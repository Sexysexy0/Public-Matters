// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../contracts/AyudaReallocationLedger.sol";

contract AyudaReallocationAudit is Test {
    AyudaReallocationLedger ledger;

    function setUp() public {
        ledger = new AyudaReallocationLedger();
    }

    function testReallocateAyuda() public {
        ledger.reallocate("Brgy. Bangkal", 100000, "KinderQueen:Health");
        AyudaReallocationLedger.Allocation memory alloc = ledger.getAllocation(0);
        assertEq(alloc.barangay, "Brgy. Bangkal");
        assertEq(alloc.amount, 100000);
        assertEq(alloc.blessingTag, "KinderQueen:Health");
    }

    function testMultipleAllocations() public {
        ledger.reallocate("Brgy. Tikay", 75000, "KinderQueen:Education");
        ledger.reallocate("Brgy. Mojon", 50000, "KinderQueen:Housing");
        assertEq(ledger.totalAllocations(), 2);
    }

    function testTimestampIntegrity() public {
        ledger.reallocate("Brgy. San Pablo", 120000, "KinderQueen:Infrastructure");
        AyudaReallocationLedger.Allocation memory alloc = ledger.getAllocation(0);
        assertGt(alloc.timestamp, 0);
    }
}
