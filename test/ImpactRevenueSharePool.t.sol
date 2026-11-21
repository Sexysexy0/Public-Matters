// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {ImpactRevenueSharePool} from "../contracts/ImpactRevenueSharePool.sol";

contract MockOperatorPrivileges {
    mapping(address => bool) public ops;
    function setOperator(address a, bool v) external { ops[a] = v; }
    function isOperator(address a) external view returns (bool) { return ops[a]; }
}

contract ImpactRevenueSharePoolTest is Test {
    ImpactRevenueSharePool pool;
    MockOperatorPrivileges opv;
    address operator = address(0xB0b);
    address contributor = address(0xC1c);

    function setUp() public {
        opv = new MockOperatorPrivileges();
        pool = new ImpactRevenueSharePool(address(opv));
        opv.setOperator(operator, true);
    }

    function test_DepositAndSetWeight() public {
        vm.deal(address(this), 1 ether);
        pool.depositRevenue{value: 1 ether}();
        vm.prank(operator);
        pool.setWeight(contributor, 5000); // 50%
        (uint256 contributions, uint256 outcomes, uint256 weight, bool claimed) = pool.shares(contributor);
        assertEq(weight, 5000);
        assertEq(pool.totalPool(), 1 ether);
    }

    function test_ClaimShare() public {
        vm.deal(address(this), 1 ether);
        pool.depositRevenue{value: 1 ether}();
        vm.prank(operator);
        pool.setWeight(contributor, 5000);
        vm.prank(contributor);
        pool.claimShare();
        (, , , bool claimed) = pool.shares(contributor);
        assertTrue(claimed);
    }

    function test_DoubleClaimReverts() public {
        vm.deal(address(this), 1 ether);
        pool.depositRevenue{value: 1 ether}();
        vm.prank(operator);
        pool.setWeight(contributor, 5000);
        vm.prank(contributor);
        pool.claimShare();
        vm.prank(contributor);
        vm.expectRevert();
        pool.claimShare();
    }

    function test_NonOperatorReverts() public {
        vm.prank(contributor);
        vm.expectRevert();
        pool.recordContribution(contributor, 100);
    }

    function test_NoWeightReverts() public {
        vm.prank(contributor);
        vm.expectRevert();
        pool.claimShare();
    }

    function test_WeightCapReverts() public {
        vm.prank(operator);
        vm.expectRevert();
        pool.setWeight(contributor, 10001);
    }
}
