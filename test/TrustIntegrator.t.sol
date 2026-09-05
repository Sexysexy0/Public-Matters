// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/OperatorPrivileges.sol";
import "../src/TrustIndex.sol";
import "../src/TrustIntegrator.sol";

contract TrustIntegratorTest is Test {
    OperatorPrivileges privileges;
    TrustIndex trust;
    TrustIntegrator integrator;
    address tester;

    function setUp() public {
        privileges = new OperatorPrivileges();
        trust = new TrustIndex(address(privileges));
        integrator = new TrustIntegrator(address(trust));

        uint256 pk = 1;
        tester = vm.addr(pk);

        // Authorize tester and the integrator contract itself as operators
        privileges.addOperator(tester);
        privileges.addOperator(address(integrator));

        assertTrue(privileges.isOperator(tester), "Operator not added");
    }

    function testInitialTrust() public view {
        assertEq(trust.getTrust(tester), 0);
    }

    function testTrustActionIncreases() public {
        vm.prank(tester);
        integrator.updateTrustViaIntegrator(tester, 10);
        assertEq(trust.getTrust(tester), 10);
    }
}
