// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../contracts/AIGovernanceMonitor.sol";

contract AIGovernanceMonitorTest is Test {
    AIGovernanceMonitor monitor;
    address admin = address(0xABCD);
    address auditor = address(0x1234);
    address agent = address(0x5678);

    function setUp() public {
        vm.prank(admin);
        monitor = new AIGovernanceMonitor();
    }

    function testAuthorizeAuditor() public {
        vm.prank(admin);
        monitor.authorizeAuditor(auditor);
        assertTrue(monitor.auditors(auditor));
    }

    function testReportIncident() public {
        vm.prank(admin);
        monitor.authorizeAuditor(auditor);

        vm.prank(auditor);
        vm.expectEmit(true, true, false, true);
        emit AIGovernanceMonitor.IncidentReported(agent, "Unauthorized action");

        monitor.reportIncident(agent, "Unauthorized action");
    }
}
