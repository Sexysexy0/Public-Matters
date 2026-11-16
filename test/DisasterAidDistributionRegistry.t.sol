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
        vm.deal(address(this), 10 ether);
        registry.fund{value: 5 ether}();
    }

    function _leaf(address a) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked(a));
    }

    function test_FundPool() public view {
        assertEq(registry.totalFunded(), 5 ether);
    }

    function test_SetMerkleRootAndClaim() public {
        bytes32 leaf = _leaf(beneficiary);
        bytes32 root = leaf; // single-leaf tree
        vm.prank(operator);
        registry.setMerkleRoot(root, 0.5 ether);

        bytes32[] memory proof = new bytes32[](0);
        bytes32 nullifier = keccak256("nullifier-1");
        vm.prank(beneficiary);
        registry.claim(proof, nullifier);

        assertEq(registry.pendingWithdrawals(beneficiary), 0.5 ether);
        assertTrue(registry.claimedNullifiers(nullifier));
    }

    function test_DoubleClaimReverts() public {
        bytes32 leaf = _leaf(beneficiary);
        vm.prank(operator);
        registry.setMerkleRoot(leaf, 0.5 ether);

        bytes32[] memory proof = new bytes32[](0);
        bytes32 nullifier = keccak256("nullifier-1");
        vm.prank(beneficiary);
        registry.claim(proof, nullifier);

        vm.prank(beneficiary);
        vm.expectRevert();
        registry.claim(proof, nullifier);
    }

    function test_InvalidProofReverts() public {
        bytes32 wrongRoot = keccak256("wrong");
        vm.prank(operator);
        registry.setMerkleRoot(wrongRoot, 0.5 ether);

        bytes32[] memory proof = new bytes32[](0);
        bytes32 nullifier = keccak256("nullifier-1");
        vm.prank(beneficiary);
        vm.expectRevert();
        registry.claim(proof, nullifier);
    }

    function test_NonOperatorCannotSetRoot() public {
        vm.prank(address(0xDEAD));
        vm.expectRevert();
        registry.setMerkleRoot(keccak256("x"), 0.5 ether);
    }

    function test_WithdrawPullBased() public {
        bytes32 leaf = _leaf(beneficiary);
        vm.prank(operator);
        registry.setMerkleRoot(leaf, 0.5 ether);

        bytes32[] memory proof = new bytes32[](0);
        bytes32 nullifier = keccak256("nullifier-1");
        vm.prank(beneficiary);
        registry.claim(proof, nullifier);

        uint256 before = beneficiary.balance;
        vm.prank(beneficiary);
        registry.withdraw();
        assertEq(beneficiary.balance, before + 0.5 ether);
        assertEq(registry.pendingWithdrawals(beneficiary), 0);
    }
}
