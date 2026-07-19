// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../contracts/JudiciaryWelfareVault.sol";
import "../contracts/InstitutionalAuditHistory.sol";

contract JudiciaryWelfareVaultTest is Test {
    JudiciaryWelfareVault vault;
    InstitutionalAuditHistory institutionalAuditHistory;

    function setUp() public {
        vault = new JudiciaryWelfareVault(0.05 ether);
        institutionalAuditHistory = new InstitutionalAuditHistory();

        // Link vault to audit history contract
        vault.setAuditHistoryAddress(address(institutionalAuditHistory));

        // Fund test accounts
        vm.deal(address(this), 10 ether);
        vm.deal(address(0x7777), 5 ether);
        vm.deal(address(0x1111), 5 ether);

        // Fund vault itself
        (bool success1,) = payable(address(vault)).call{value: 5 ether}("");
        require(success1, "Funding failed");
    }

    function test_WelfarePlanHydrationAndClaimSettlement() public {
        vm.prank(address(0x7777));
        vault.depositContribution{value: 0.05 ether}();

        vm.prank(address(0x7777));
        uint256 claimId1 = vault.fileWelfareClaim(1 ether, keccak256("MedicalHash"));

        vm.prank(address(0x1111));
        vault.settleWelfareClaim(claimId1);

        (, address claimant1, uint256 amount1,,, bool settled1) = vault.claims(claimId1);
        assertEq(claimant1, address(0x7777));
        assertEq(amount1, 1 ether);
        assertTrue(settled1);
    }
}
