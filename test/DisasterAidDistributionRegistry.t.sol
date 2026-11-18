// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {DisasterAidDistributionRegistry} from "../contracts/DisasterAidDistributionRegistry.sol";

contract MockOperatorPrivileges {
    mapping(address => bool) public ops;
    function setOperator(address a, bool v) external { ops[a] = v; }
    function isOperator(address a) external view returns (bool) { return ops[a]; }
}

contract DisasterAidDistributionRegistryTest is Test {
    DisasterAidDistributionRegistry registry;
    MockOperatorPrivileges opv;
    address operator = address(0xB0b);
    address beneficiary = address(0xC1c);

    function setUp() public {
        opv = new MockOperatorPrivileges();
        registry = new DisasterAidDistributionRegistry(address(opv));
        opv.setOperator(operator, true);
        vm.deal(address(registry), 10 ether);
    }

    function test_RegisterAid() public {
        vm.prank(operator);
        uint256 rid = registry.registerAid(beneficiary, 1 ether, "Flood relief");
        (address ben, uint256 amt, , , , , DisasterAidDistributionRegistry.AidStatus status) = registry.records(rid);
        assertEq(ben, beneficiary);
        assertEq(amt, 1 ether);
        assertEq(uint256(status), 0); // Registered
    }

    function test_VerifyAndClaim() public {
        vm.prank(operator);
        uint256 rid = registry.registerAid(beneficiary, 1 ether, "Flood relief");
        vm.prank(operator);
        registry.verifyAid(rid);
        vm.prank(beneficiary);
        registry.claimAid(rid);
        (, , , , , , DisasterAidDistributionRegistry.AidStatus status) = registry.records(rid);
        assertEq(uint256(status), 2); // Claimed
        assertEq(beneficiary.balance, 1 ether);
    }

    function test_ClaimBeforeVerifyReverts() public {
        vm.prank(operator);
        uint256 rid = registry.registerAid(beneficiary, 1 ether, "Test");
        vm.prank(beneficiary);
        vm.expectRevert();
        registry.claimAid(rid);
    }

    function test_DoubleClaimReverts() public {
        vm.prank(operator);
        uint256 rid = registry.registerAid(beneficiary, 1 ether, "Test");
        vm.prank(operator);
        registry.verifyAid(rid);
        vm.prank(beneficiary);
        registry.claimAid(rid);
        vm.prank(beneficiary);
        vm.expectRevert();
        registry.claimAid(rid);
    }

    function test_CancelAid() public {
        vm.prank(operator);
        uint256 rid = registry.registerAid(beneficiary, 1 ether, "Test");
        vm.prank(operator);
        registry.cancelAid(rid);
        (, , , , , , DisasterAidDistributionRegistry.AidStatus status) = registry.records(rid);
        assertEq(uint256(status), 3); // Cancelled
    }

    function test_NonOperatorReverts() public {
        vm.prank(beneficiary);
        vm.expectRevert();
        registry.registerAid(beneficiary, 1 ether, "Test");
    }
}
