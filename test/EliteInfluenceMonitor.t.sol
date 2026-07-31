// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../contracts/EliteInfluenceMonitor.sol";

contract EliteInfluenceMonitorTest is Test {
    EliteInfluenceMonitor public monitor;
    address public chiefOperator = address(1);
    address public authorizedInformant = address(2);
    address public rogueBot = address(3); // Representative of corporate spam

    function setUp() public {
        vm.prank(chiefOperator);
        monitor = new EliteInfluenceMonitor();
    }

    function test_AuthorizeInformant() public {
        vm.prank(chiefOperator);
        monitor.authorizeInformant(authorizedInformant);
        assertTrue(monitor.authorizedInformants(authorizedInformant));
    }

    function test_RevertWhen_RogueBotAttemptsToLog() public {
        // Ang isang rogue/unauthorized user ay dapat ma-block
        vm.prank(rogueBot);
        vm.expectRevert("Unauthorized: Only verified Informants or Chief Operator can log observations.");
        monitor.logObservation("Public Infrastructure", 90, "Privatization of Water");
    }

    function test_LogObservation_TriggersSystemFreeze() public {
        // 1. Authorize the informant
        vm.startPrank(chiefOperator);
        monitor.authorizeInformant(authorizedInformant);
        vm.stopPrank();

        // 2. Informant logs a high-volatility event (>75)
        vm.prank(authorizedInformant);
        monitor.logObservation("Data Center Zonal Laws", 88, "HB 2014 Corporate Tax Siphon");

        // 3. Verify that the public audit / freeze was triggered
        (string memory topic, uint256 volatility, string memory policy, bool requiresAudit, address informant, ) = monitor.alerts(1);
        
        assertEq(topic, "Data Center Zonal Laws");
        assertEq(volatility, 88);
        assertEq(policy, "HB 2014 Corporate Tax Siphon");
        assertTrue(requiresAudit);
        assertEq(informant, authorizedInformant);
    }
}
