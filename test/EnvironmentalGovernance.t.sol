// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/OperatorPrivileges.sol";
import "../src/ExtractivePermitRegistry.sol";
import "../src/EnvironmentalBondEscrow.sol";

contract EnvironmentalGovernanceTest is Test {
    OperatorPrivileges privileges;
    ExtractivePermitRegistry permitRegistry;
    EnvironmentalBondEscrow escrow;

    address op = vm.addr(1);
    address company = vm.addr(2);
    address communityFund = vm.addr(3);

    bytes32 constant PERMIT_ID = keccak256("PERMIT-2026-001");
    bytes32 constant COMPANY_HASH = keccak256("Mining Corp");
    bytes32 constant LOCATION_HASH = keccak256("Mt. Bagyo, Rizal");
    bytes32 constant ECC_HASH = keccak256("ECC-Approved");

    function setUp() public {
        privileges = new OperatorPrivileges();
        privileges.addOperator(op);
        
        permitRegistry = new ExtractivePermitRegistry(address(privileges));
        escrow = new EnvironmentalBondEscrow(address(privileges), communityFund);
    }

    function testIssuePermit() public {
        vm.prank(op);
        permitRegistry.issuePermit(PERMIT_ID, COMPANY_HASH, LOCATION_HASH, ECC_HASH, 365 days);

        ExtractivePermitRegistry.Permit memory p = permitRegistry.getPermit(PERMIT_ID);
        assertEq(p.issuer, op); // Naka-record ang opisyal
        assertTrue(p.active);
    }

    function testDisasterForfeitsBondToCommunity() public {
        // 1. Permit is issued
        vm.prank(op);
        permitRegistry.issuePermit(PERMIT_ID, COMPANY_HASH, LOCATION_HASH, ECC_HASH, 365 days);

        // 2. Company deposits 10 ETH bond
        vm.deal(company, 10 ether);
        vm.prank(company);
        escrow.depositBond{value: 10 ether}(PERMIT_ID);

        // 3. Mountain collapses, operator triggers forfeit
        vm.prank(op);
        escrow.forfeitBond(PERMIT_ID);

        // 4. Check if community fund got the money
        assertEq(communityFund.balance, 10 ether);
        assertEq(escrow.bondAmounts(PERMIT_ID), 0);
    }

    function testCompliantMiningReturnsBond() public {
        vm.prank(op);
        permitRegistry.issuePermit(PERMIT_ID, COMPANY_HASH, LOCATION_HASH, ECC_HASH, 365 days);

        vm.deal(company, 10 ether);
        vm.prank(company);
        escrow.depositBond{value: 10 ether}(PERMIT_ID);

        // Company was compliant, return the bond
        vm.prank(op);
        escrow.releaseBond(PERMIT_ID, payable(company));

        assertEq(company.balance, 10 ether);
    }
}
