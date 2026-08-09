// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/TrustIndex.sol";

contract TrustIndexTest is Test {
    TrustIndex public trust;

    address public steward = address(this);
    address public user = makeAddr("user");

    function setUp() public {
        trust = new TrustIndex(100, 10);
    }

    function test_ActionIncreasesIndex() public {
        assertEq(trust.getTrustIndex(), 100);
        trust.reportTrustAction(0); // uses base weight (10)
        assertEq(trust.getTrustIndex(), 110);
    }

    function test_CustomWeightWorks() public {
        trust.reportTrustAction(25);
        assertEq(trust.getTrustIndex(), 125);
    }

    function test_SetbackDecreasesIndex() public {
        trust.reportTrustSetback(10);
        assertEq(trust.getTrustIndex(), 90);
    }

    function test_OnlyStewardCanChangeBaseWeight() public {
        vm.prank(user);
        vm.expectRevert("Only the steward");
        trust.setBaseWeight(50);

        trust.setBaseWeight(50);
        assertEq(trust.baseActionWeight(), 50);
    }
}
