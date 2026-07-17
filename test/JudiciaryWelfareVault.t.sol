// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import "../contracts/JudiciaryWelfareVault.sol";
import "../contracts/InstitutionalAuditHistory.sol";

contract JudiciaryWelfareVaultTest is Test {
    JudiciaryWelfareVault public vault;
    InstitutionalAuditHistory public auditHistory;

    address public guardianWallet = address(0x1111);
    address public courtStaff = address(0x7777);
    bytes32 public medicalHash = keccak256(abi.encodePacked("MEDICAL_BILL_REIMBURSEMENT_DATA"));

    uint256 public minimalContribution = 0.05 ether;

    function setUp() public {
        // HYDRATION: Bigyan ng pondo ang test contract para hindi mag-revert ang transfer
        vm.deal(address(this), 20 ether);

        vm.startPrank(guardianWallet);
        auditHistory = new InstitutionalAuditHistory();
        vault = new JudiciaryWelfareVault(minimalContribution);

        vault.setAuditHistoryAddress(address(auditHistory));
        auditHistory.setLoggerAuthorization(address(vault), true);
        vm.stopPrank();

        // Ligtas na mag-seed ng liquidity sa welfare vault pool
        payable(address(vault)).transfer(10 ether);

        vm.deal(courtStaff, 5 ether);
    }

    function test_WelfarePlanHydrationAndClaimSettlement() public {
        // Hakbang A: Ang empleyado ay magbabayad ng minimal tier contribution (Korte Suprema Framework)
        vm.prank(courtStaff);
        vault.depositContribution{value: minimalContribution}();
        assertTrue(vault.activeCoverage(courtStaff));

        // Hakbang B: Pagsusumite ng pormal na medical claim
        vm.prank(courtStaff);
        uint256 claimId = vault.fileWelfareClaim(1 ether, medicalHash);
        assertEq(claimId, 1);

        // Hakbang C: Pag-settle ng Guardian sa claim mula sa uniform healthcare fund pool
        vm.prank(guardianWallet);
        vault.settleWelfareClaim(claimId);

        (,,,, bool approved, bool settled) = vault.claims(1);
        assertTrue(approved);
        assertTrue(settled);

        // Hakbang D: Sinusuri kung pumasok ang +1 grantsReceived record telemetry on-chain
        (, uint256 grants,,,,) = auditHistory.viewHistory(courtStaff);
        assertEq(grants, 1);
    }
}
