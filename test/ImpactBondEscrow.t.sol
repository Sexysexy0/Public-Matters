// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "forge-std/Test.sol";
import "../src/OperatorPrivileges.sol";
import "../src/ImpactBondEscrow.sol";

contract ImpactBondEscrowTest is Test {
    OperatorPrivileges privileges;
    ImpactBondEscrow escrow;
    address op = vm.addr(1);
    address donor = vm.addr(2);
    address ngo = vm.addr(3);
    bytes32 constant PID = keccak256("River-Cleanup-01");

    function setUp() public {
        privileges = new OperatorPrivileges();
        privileges.addOperator(op);
        escrow = new ImpactBondEscrow(address(privileges));
    }

    function testImpactRelease() public {
        vm.deal(donor, 10 ether); // Give the donor 10 ETH to spend
        vm.prank(donor);
        escrow.createProject{value: 10 ether}(PID, ngo);

        vm.prank(ngo);
        escrow.submitImpactProof(PID, keccak256("Cleanup_Photo_IPFS"));

        vm.prank(op);
        escrow.verifyImpactAndRelease(PID, 5 ether);

        assertEq(ngo.balance, 5 ether);
        assertEq(escrow.verifiedProofCount(PID), 1);
    }
}
