// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import { } from "../contracts/JudicialDisputeRouter.sol";
import { } from "../contracts/InstitutionalAuditHistory.sol";

contract JudicialDisputeTest is Test {
    JudicialDisputeRouter public router;
    InstitutionalAuditHistory public auditHistory;

    address public masterContractor = address(0x9999);
    address public certifiedMediatorNode = address(0xCC15);
    address public litigantClaimant = address(0xAAAA);
    address public litigantRespondent = address(0xBBBB);

    bytes32 public sampleResolution = keccak256(abi.encodePacked("CAM_COMPROMISE_AGREEMENT_APPROVED"));

    function setUp() public {
        vm.deal(address(this), 50 ether);

        vm.startPrank(masterContractor);
        auditHistory = new InstitutionalAuditHistory();
        router = new JudicialDisputeRouter();

        router.setAuditHistoryAddress(address(auditHistory));
        auditHistory.setLoggerAuthorization(address(router), true);

        router.setMediatorClearance(certifiedMediatorNode, true);
        vm.stopPrank();

        vm.deal(litigantClaimant, 10 ether);
    }

    function test_SuccessfulCourtAnnexedMediationFlow() public {
        // Hakbang A: Ang claimant ay magpapadala ng pondo sa mediation escrow
        vm.prank(litigantClaimant);
        uint256 disputeId = router.referToMediation{value: 5 ether}(litigantRespondent, certifiedMediatorNode);
        assertEq(disputeId, 1);

        (,,,, JudicialDisputeRouter.MediationStatus status, address mediator,) = router.disputes(1);
        assertTrue(status == JudicialDisputeRouter.MediationStatus.UnderMediation);
        assertEq(mediator, certifiedMediatorNode);

        uint256 initialClaimantBalance = litigantClaimant.balance;
        uint256 initialRespondentBalance = litigantRespondent.balance;

        // Hakbang B: Ang mediator node ay maglalapat ng compromise settlement split
        vm.prank(certifiedMediatorNode);
        router.executeCompromiseSettlement(disputeId, 3 ether, 2 ether, sampleResolution);

        // I-verify ang payouts matrix kung pumasok sa native balances
        assertEq(litigantClaimant.balance, initialClaimantBalance + 3 ether);
        assertEq(litigantRespondent.balance, initialRespondentBalance + 2 ether);

        // Hakbang C: Pormal na verification ng mediation case lifecycle resolution parameters
        (,,,, JudicialDisputeRouter.MediationStatus finalStatus,, bytes32 resolutionHash) = router.disputes(1);
        assertTrue(finalStatus == JudicialDisputeRouter.MediationStatus.Settled);
        assertEq(resolutionHash, sampleResolution);
    }
}
