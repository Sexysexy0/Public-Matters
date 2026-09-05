// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/OperatorPrivileges.sol";
import "../src/TrustIndex.sol";

contract TrustIndexTest is Test {
    OperatorPrivileges privileges;
    TrustIndex trust;
    address tester;

    function setUp() public {
        privileges = new OperatorPrivileges();
        trust = new TrustIndex(address(privileges));
        uint256 pk = 1;
        tester = vm.addr(pk);

        privileges.addOperator(tester);
        assertTrue(privileges.isOperator(tester), "Operator not added");
    }

    function testUpdateTrustPositive() public {
        vm.prank(tester);
        trust.updateTrust(tester, 10);
        assertEq(trust.getTrust(tester), 10);
    }

    function testUpdateTrustNegative() public {
        vm.prank(tester);
        trust.updateTrust(tester, -5);
        assertEq(trust.getTrust(tester), 0);
    }
}
