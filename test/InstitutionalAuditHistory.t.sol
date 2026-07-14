// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import "../contracts/InstitutionalAuditHistory.sol";
import "../contracts/WhistleblowerSanctuary.sol";
import "../contracts/ComplianceRecoveryEscrow.sol";
import "../contracts/PublicBenefitGrant.sol";

contract InstitutionalAuditHistoryTest is Test {
    InstitutionalAuditHistory public auditHistory;
    WhistleblowerSanctuary public sanctuary;
    ComplianceRecoveryEscrow public escrow;
    PublicBenefitGrant public targetGrant;

    address public guardianWallet = address(0x1111);
    address public whistleblower = address(0x2222);
    address public badInstitution = address(0x3333);
    bytes32 public intelHash = keccak256(abi.encodePacked("BREACH_OF_PROTOCOL_DATA"));

    function setUp() public {
        vm.startPrank(guardianWallet);
        auditHistory = new InstitutionalAuditHistory();
        sanctuary = new WhistleblowerSanctuary();
        targetGrant = new PublicBenefitGrant();
        escrow = new ComplianceRecoveryEscrow(address(targetGrant));

        // Konfigurasyon ng Inter-Contract Links
        sanctuary.setAuditHistoryAddress(address(auditHistory));
        escrow.setAuditHistoryAddress(address(auditHistory));

        // Pagbibigay ng karapatan sa sub-contracts na mag-log sa kasaysayan
        auditHistory.setLoggerAuthorization(address(sanctuary), true);
        auditHistory.setLoggerAuthorization(address(escrow), true);
        vm.stopPrank();

        vm.deal(badInstitution, 10 ether);
    }

    function test_CrossContractWarningLogging() public {
        vm.prank(whistleblower);
        sanctuary.submitIntel(intelHash, badInstitution);

        (uint256 freezes, uint256 grants, uint256 warnings,,,) = auditHistory.viewHistory(badInstitution);
        assertEq(warnings, 1);
        assertEq(freezes, 0);
        assertEq(grants, 0);
    }

    function test_CrossContractForfeitureFreezeLogging() public {
        // Hakbang A: Ang masamang institusyon ay nagpasok ng kanilang collateral
        vm.prank(badInstitution);
        uint256 caseId = escrow.initiateRecovery{value: 5 ether}("System Realignment", 7 days);

        // Hakbang B: Warp sa hinaharap para lumipas ang deadline
        vm.warp(block.timestamp + 8 days);

        // Hakbang C: Forfeit ng Guardian ang collateral dahil sa paglabag
        vm.prank(guardianWallet);
        escrow.forfeitCollateral(caseId);

        // Hakbang D: Pagsusuri kung pumasok ang +1 freeze record sa kasaysayan ng Audit History
        (uint256 freezes,,,,,) = auditHistory.viewHistory(badInstitution);
        assertEq(freezes, 1);
    }
}
