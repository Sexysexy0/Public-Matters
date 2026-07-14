// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import {Test} from "forge-std/Test.sol";
import "../contracts/ComplianceRecoveryEscrow.sol";
import "../contracts/PublicBenefitGrant.sol";

contract ComplianceRecoveryEscrowTest is Test {
    ComplianceRecoveryEscrow public escrow;
    PublicBenefitGrant public targetGrant;
    address public guardianWallet = address(0x1111);
    address public externalAttacker = address(0x2222);
    address public institution = address(0x4444);

    function setUp() public {
        vm.deal(guardianWallet, 100 ether);
        vm.deal(institution, 10 ether);
        vm.prank(guardianWallet);
        targetGrant = new PublicBenefitGrant();
        vm.prank(guardianWallet);
        escrow = new ComplianceRecoveryEscrow(address(targetGrant));
        vm.prank(institution);
        escrow.initiateRecovery{value: 5 ether}("Structural Improvement Alpha", 30 days);
    }

    function test_VaultLiquidityVerification() public view {
        assertEq(address(escrow).balance, 5 ether);
    }

    function test_ApproveRecoveryFlow() public {
        vm.prank(guardianWallet);
        escrow.approveRecovery(1);
        assertEq(address(escrow).balance, 0);
    }

    function test_ForfeitCollateralFlow() public {
        vm.warp(block.timestamp + 31 days);
        vm.prank(guardianWallet);
        escrow.forfeitCollateral(1);
        assertEq(address(escrow).balance, 0);
    }
}
