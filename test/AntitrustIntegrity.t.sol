// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { Test } from "forge-std/Test.sol";
import "../contracts/AntitrustIntegrity.sol";

contract AntitrustIntegrityTest is Test {
    AntitrustIntegrity ai;
    address guardian;
    address auditor;
    address councilA;
    address councilB;
    address submitter;
    address reporter;

    function setUp() public {
        guardian = address(0x1);
        auditor = address(0x2);
        councilA = address(0x3);
        councilB = address(0x4);
        submitter = address(0x5);
        reporter = address(0x6);

        // deploy contract as guardian
        vm.prank(guardian);
        address[] memory initialCouncil = new address[](2);
        initialCouncil[0] = councilA;
        initialCouncil[1] = councilB;
        ai = new AntitrustIntegrity(initialCouncil, 2);

        // assign auditor role
        vm.prank(guardian);
        ai.assignRole(auditor, AntitrustIntegrity.Role.Auditor);
    }

    function testFileWhistleAndPayBounty() public {
        // 1) file a whistle without bounty (case 1)
        vm.prank(reporter);
        uint caseId1 = ai.fileWhistle(bytes32("QmExampleHash"));

        // 2) fund the reporter so it can send value with the next call
        vm.deal(reporter, 1 ether);

        // 3) file a whistle with bounty (case 2) — value is sent from reporter
        vm.prank(reporter);
        uint caseId2 = ai.fileWhistle{value: 0.1 ether}(bytes32("QmExampleHash2"));

        // 4) auditor validates and pays the bounty for the case that actually has the bounty
        vm.prank(auditor);
        ai.validateAndPayBounty(caseId2, payable(reporter), 0.1 ether);

        // 5) assert stored evidence for case1 (unchanged) and that case2 bounty exists and validated
        ( , , bytes32 evidenceHash1, uint bounty1, bool validated1, ) = ai.whistleCases(caseId1);
        ( , , bytes32 evidenceHash2, uint bounty2, bool validated2, ) = ai.whistleCases(caseId2);

        assertEq(evidenceHash1, bytes32("QmExampleHash"));
        assertEq(evidenceHash2, bytes32("QmExampleHash2"));
        assertEq(bounty2, 0.1 ether);
        assertTrue(validated2);
    }

    function testSubmitMergerAndCouncilApprove() public {
        vm.deal(submitter, 1 ether);
        vm.prank(submitter);
        uint mergerId = ai.submitMerger{value: 0.5 ether}("AcmeCorp");

        vm.prank(councilA);
        ai.voteMerger(mergerId, true);
        vm.prank(councilB);
        ai.voteMerger(mergerId, true);

        ( , address s, string memory name, uint deposit, , , , bool finalized, bool approved) = ai.mergerInfo(mergerId);
        assertEq(s, submitter);
        assertTrue(finalized);
        assertTrue(approved);
    }

    function testTriggerInvestigationAndReport() public {
        vm.deal(submitter, 1 ether);
        vm.prank(submitter);
        uint mergerId = ai.submitMerger{value: 0.2 ether}("Beta");

        vm.prank(auditor);
        uint invId = ai.triggerInvestigation(mergerId, address(0x7));

        vm.prank(address(0x7));
        ai.submitInvestigationReport(invId, bytes32("QmReportHash"));

        ( , , address investigator, bytes32 reportHash, bool completed, ) = ai.investigations(invId);
        assertEq(investigator, address(0x7));
        assertEq(reportHash, bytes32("QmReportHash"));
        assertTrue(completed);
    }
}
