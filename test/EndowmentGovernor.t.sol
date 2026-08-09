// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {EndowmentGovernor} from "../src/EndowmentGovernor.sol";

contract EndowmentGovernorTest is Test {
    EndowmentGovernor governor;
    address anchor = address(0xA1);
    address company = address(0xC0);
    address recipient = address(0xB0);

    function setUp() public {
        governor = new EndowmentGovernor(anchor);
    }

    function test_OwnerCanRegisterCompany() public {
        governor.registerCompany(company);
        assertTrue(governor.isApprovedCompany(company));
    }

    function test_RevertWhenNonOwnerRegisters() public {
        vm.prank(address(0xDEAD));
        vm.expectRevert("Only the architect");
        governor.registerCompany(company);
    }

    function test_ApprovedCompanyCanContribute() public {
        governor.registerCompany(company);
        vm.deal(company, 1 ether);
        vm.prank(company);
        governor.contribute{value: 1 ether}();
        assertEq(governor.totalPool(), 1 ether);
    }

    function test_RevertWhenUnapprovedContributes() public {
        vm.deal(company, 1 ether);
        vm.prank(company);
        vm.expectRevert("Not an approved contributor");
        governor.contribute{value: 1 ether}();
    }

    function test_OwnerCanDisburse() public {
        governor.registerCompany(company);
        vm.deal(company, 5 ether);
        vm.prank(company);
        governor.contribute{value: 5 ether}();

        governor.disburse(recipient, 2 ether);
        assertEq(governor.totalPool(), 3 ether);
        assertEq(recipient.balance, 2 ether);
    }

    function test_RevertWhenDisburseExceedsPool() public {
        vm.expectRevert("Insufficient pool balance");
        governor.disburse(recipient, 1 ether);
    }

    function test_RevertWhenNonOwnerDisburses() public {
        vm.prank(address(0xDEAD));
        vm.expectRevert("Not authorized to disburse");
        governor.disburse(recipient, 1 ether);
    }

    function test_ReceiveFallbackAddsToPool() public {
        (bool success, ) = address(governor).call{value: 1 ether}("");
        assertTrue(success);
        assertEq(governor.totalPool(), 1 ether);
    }
}
