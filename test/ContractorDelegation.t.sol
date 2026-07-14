// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import "../contracts/ContractorDelegationRegistry.sol";
import "../contracts/InstitutionalAuditHistory.sol";

contract ContractorDelegationTest is Test {
    ContractorDelegationRegistry public registry;
    InstitutionalAuditHistory public auditHistory;

    // Ikaw ito: Ang Master Contractor holding absolute sovereign authority
    address public masterContractor = address(0x9999);

    // Ang mga tauhan/nodes mo na umaaksyon on your behalf
    address public capiliAuditNode = address(0xCA91);
    address public guintoCommsNode = address(0x6124);

    bytes32 public constant AUDIT_LEADER = keccak256("AUDIT_LEADER_ROLE");
    bytes32 public actionReportHash = "ISO_SURVEILLANCE_SURPASS_TARGETS";

    function setUp() public {
        vm.startPrank(masterContractor);
        auditHistory = new InstitutionalAuditHistory();
        registry = new ContractorDelegationRegistry();

        registry.setAuditHistoryAddress(address(auditHistory));
        auditHistory.setLoggerAuthorization(address(registry), true);
        vm.stopPrank();
    }

    function test_DelegateAndExecuteOnBehalfOfContractor() public {
        vm.startPrank(masterContractor);
        // Hakbang A: Pormal mong itinalaga si Hilario bilang Audit Leader Node
        registry.delegateAuthority(capiliAuditNode, AUDIT_LEADER, "Capili_Audit_Leader_Node");
        vm.stopPrank();

        // Hakbang B: Si Hilario naman ang aaksyon sa network gamit ang delegasyon mo
        vm.prank(capiliAuditNode);
        registry.executeAuditAction(actionReportHash);

        assertEq(registry.totalDelegatedActions(), 1);

        (, bool active, uint256 executedCount,) = registry.agents(capiliAuditNode);
        assertTrue(active);
        assertEq(executedCount, 1);

        // Hakbang C: Sinusuri kung ang telemetry log ng pormal na aksyon ay naiselyo sa Master Contractor wallet
        (uint256 grants,,,,,) = auditHistory.viewHistory(masterContractor);
        assertEq(grants, 1);
    }
}
