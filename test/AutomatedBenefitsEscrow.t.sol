// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "forge-std/Test.sol";
import "../src/OperatorPrivileges.sol";
import "../src/AutomatedBenefitsEscrow.sol";

contract AutomatedBenefitsEscrowTest is Test {
    OperatorPrivileges privileges;
    AutomatedBenefitsEscrow escrow;
    
    address op = vm.addr(1); // Could be HR or Verified Hospital
    address memberWallet = vm.addr(2);
    
    bytes32 constant MEMBER = keccak256("SSS-EMERVIN");
    bytes32 constant HOSPITAL = keccak256("PGH-Manila");
    bytes32 constant DIAGNOSIS = keccak256("Cancer-Stage-2-IPFS");
    bytes32 constant CLAIM_ID = keccak256("Claim-001");

    function setUp() public {
        privileges = new OperatorPrivileges();
        privileges.addOperator(op);
        escrow = new AutomatedBenefitsEscrow(address(privileges));
    }

    function testInstantReleaseOnMedicalVerification() public {
        // 1. HR logs 14 years of contributions (simulated as 10 ETH)
        vm.deal(op, 10 ether);
        vm.prank(op);
        escrow.logContribution{value: 10 ether}(MEMBER, 10 ether);

        // 2. Member files cancer claim
        vm.prank(memberWallet);
        escrow.fileClaim(CLAIM_ID, MEMBER, HOSPITAL, DIAGNOSIS, 5 ether);

        // 3. Verified Operator/Hospital approves instantly
        vm.prank(op);
        escrow.verifyAndRelease(CLAIM_ID, payable(memberWallet));

        // 4. The member receives funds INSTANTLY. No runaround.
        assertEq(memberWallet.balance, 5 ether);
        assertTrue(escrow.getClaim(CLAIM_ID).released);
    }
}
