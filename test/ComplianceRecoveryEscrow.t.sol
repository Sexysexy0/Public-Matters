// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "forge-std/Test.sol";
import "../contracts/ComplianceRecoveryEscrow.sol";
import "../contracts/PublicBenefitGrant.sol";
contract ComplianceRecoveryEscrowTest is Test {
    ComplianceRecoveryEscrow public escrow;
    PublicBenefitGrant public targetGrant;
    address public guardianWallet = address(0x1111);
    address public externalAttacker = address(0x2222);
    function setUp() public {
        vm.deal(guardianWallet, 100 ether);
        vm.startPrank(guardianWallet);
        targetGrant = new PublicBenefitGrant();
        escrow = new ComplianceRecoveryEscrow(address(targetGrant));
        payable(address(escrow)).transfer(5 ether);
        vm.stopPrank();
    }
    function test_VaultLiquidityVerification() public view {
        assertEq(address(escrow).balance, 5 ether);
    }
    function test_GuardianApprovalAuthority() public {
        vm.prank(externalAttacker);
        vm.expectRevert();
        escrow.approveRecovery(1);
    }
}
