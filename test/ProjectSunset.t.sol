// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "forge-std/Test.sol";
import "../contracts/governance/ProjectSunset.sol";
import "../contracts/governance/InstitutionalAuditHistory.sol";
import "../contracts/governance/GovernanceSimulation.sol";

contract ProjectSunsetTest is Test {
    ProjectSunset sunset;
    InstitutionalAuditHistory audit;
    GovernanceSimulation sim;

    function setUp() public {
        audit = new InstitutionalAuditHistory();
        sim = new GovernanceSimulation();
        sunset = new ProjectSunset(address(audit), address(sim));
    }

    function testCreateProposalGasBenchmark() public {
        uint256 gasBefore = gasleft();
        sunset.createProposal("TestProject");
        uint256 gasUsed = gasBefore - gasleft();
        assertLt(gasUsed, 100000, "Gas too high for createProposal");
    }

    function testVoteAndExecuteGasBenchmark() public {
        sunset.createProposal("CriticalModule");
        sunset.vote(1, true);
        uint256 gasBefore = gasleft();
        sunset.executeProposal(1);
        uint256 gasUsed = gasBefore - gasleft();
        assertLt(gasUsed, 200000, "Gas too high for executeProposal");
    }

    function testVoteFailsInvalidProposal() public {
        vm.expectRevert("Invalid proposal");
        sunset.vote(99, true);
    }

    function testExecuteFailsNotApproved() public {
        sunset.createProposal("NonCritical");
        sunset.vote(1, false);
        vm.expectRevert("Not approved");
        sunset.executeProposal(1);
    }

    function testExecuteFailsAlreadyExecuted() public {
        sunset.createProposal("CriticalModule");
        sunset.vote(1, true);
        sunset.executeProposal(1);
        vm.expectRevert("Already executed");
        sunset.executeProposal(1);
    }
}
