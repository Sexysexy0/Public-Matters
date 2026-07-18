// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../contracts/AntitrustIntegrity.sol";

contract AntitrustIntegrityTest is Test {
    AntitrustIntegrity ai;

    function setUp() public {
        address[] memory guardians = new address[](1);
        guardians[0] = address(this);
        ai = new AntitrustIntegrity(guardians, 0.1 ether);
    }

    function testFileWhistleAndPayBounty() public {
        uint caseId1 = ai.fileWhistle(bytes32("QmExampleHash"));
        uint caseId2 = ai.fileWhistle{value: 0.1 ether}(bytes32("QmExampleHash2"));

        // Palitan 'evidenceRecords' ng eksaktong pangalan sa kontrata
        assertEq(ai.evidenceRecords(caseId1), bytes32("QmExampleHash"));
        assertEq(ai.evidenceRecords(caseId2), bytes32("QmExampleHash2"));
    }

    function testTriggerInvestigationAndReport() public {
        uint invId = ai.triggerInvestigation(1);
        ai.submitInvestigationReport(invId, bytes32("QmReportHash"));

        // Palitan 'reports' ng eksaktong pangalan sa kontrata
        assertEq(ai.reports(invId), bytes32("QmReportHash"));
    }
}
