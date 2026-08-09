// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/TrustIndex.sol";
import "../src/TrustIntegrator.sol";

contract TrustIntegratorTest is Test {
    TrustIndex public trust;
    TrustIntegrator public integrator;

    address public steward = address(this);

    function setUp() public {
        trust = new TrustIndex(100, 10);
        integrator = new TrustIntegrator(address(trust));
    }

    function test_LogPositiveActionUpdatesTrust() public {
        assertEq(trust.getTrustIndex(), 100);
        integrator.logPositiveAction(0);
        assertEq(trust.getTrustIndex(), 110);
    }

    function test_LogSetbackUpdatesTrust() public {
        assertEq(trust.getTrustIndex(), 100);
        integrator.logSetback(10);
        assertEq(trust.getTrustIndex(), 90);
    }
}
