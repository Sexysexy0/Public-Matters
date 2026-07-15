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

        vm.prank(guardian);
        address[] memory initialCouncil = new address[](2);
        initialCouncil[0] = councilA;
        initialCouncil[1] = councilB;
        ai = new AntitrustIntegrity(initialCouncil, 2);

        vm.prank(guardian);
        ai.assignRole(auditor, AntitrustIntegrity.Role.Auditor);
    }

    function testFileWhistleAndPayBounty() public {
        vm.prank(reporter);
        uint caseId = ai.fileWhistle(bytes32("QmExampleHash"));

        vm.deal(address(this), 1 ether);
        vm.prank(reporter);
        ai.fileWhistle{value: 0.1 ether}(bytes32("QmExampleHash2"));

        vm.prank(auditor);
        ai.validateAndPayBounty(caseId, payable(reporter), 0.1 ether);

        ( , , bytes32 evidenceHash, uint bounty, bool validated, ) = ai.whistleCases(caseId);
        assertEq(evidenceHash, bytes32("QmExampleHash"));
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
