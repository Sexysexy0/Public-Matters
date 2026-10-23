// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {HogIndustryPolicyRegistry} from "../../src/hog-industry/HogIndustryPolicyRegistry.sol";

contract HogIndustryPolicyRegistryTest is Test {
    HogIndustryPolicyRegistry registry;

    address deployer = makeAddr("deployer");
    address attacker = makeAddr("attacker");

    uint256 constant DEADLINE = 10 days;

    event ActionProposed(
        uint256 indexed id,
        HogIndustryPolicyRegistry.PolicyKind indexed kind,
        string description,
        uint256 primaryParam,
        uint256 secondaryParam,
        uint256 deadline
    );

    function setUp() public {
        vm.prank(deployer);
        registry = new HogIndustryPolicyRegistry();
    }

    // ------------------------------------------------------------------
    // Deployment
    // ------------------------------------------------------------------

    function test_DeployerBecomesAdminAndFederation() public view {
        assertEq(registry.admin(), deployer);
        assertEq(registry.federationRep(), deployer);
    }

    function test_DefaultsMatchFederationDemands() public view {
        (
            uint256 inQuotaTariffBps,
            uint256 outQuotaTariffBps,
            uint256 floorPriceCentavos,
            uint256 minPauseDays,
            uint256 federationPauseDays
        ) = registry.defaults();
        assertEq(inQuotaTariffBps, 3000); // 30%
        assertEq(outQuotaTariffBps, 4000); // 40%
        assertEq(floorPriceCentavos, 21000); // P210/kg
        assertEq(minPauseDays, 60);
        assertEq(federationPauseDays, 120);
    }

    // ------------------------------------------------------------------
    // Propose
    // ------------------------------------------------------------------

    function test_ProposeAction() public {
        vm.prank(deployer);
        uint256 id = registry.proposeAction(
            uint8(HogIndustryPolicyRegistry.PolicyKind.TARIFF_RESTORATION),
            "Restore 30% in-quota and 40% out-quota tariffs",
            3000,
            4000,
            block.timestamp + DEADLINE
        );

        assertEq(id, 1);
        assertEq(registry.totalActions(), 1);
        assertEq(registry.actionCountByKind(HogIndustryPolicyRegistry.PolicyKind.TARIFF_RESTORATION), 1);

        HogIndustryPolicyRegistry.PolicyAction memory action = registry.getAction(id);
        assertEq(uint8(action.status), uint8(HogIndustryPolicyRegistry.PolicyStatus.PROPOSED));
        assertEq(action.proposer, deployer);
        assertEq(action.primaryParam, 3000);
        assertEq(action.secondaryParam, 4000);
    }

    function test_OnlyFederationCanPropose() public {
        vm.prank(attacker);
        vm.expectRevert(HogIndustryPolicyRegistry.Unauthorized.selector);
        registry.proposeAction(
            uint8(HogIndustryPolicyRegistry.PolicyKind.IMPORT_PAUSE), "Pause imports", 60, 0, block.timestamp + DEADLINE
        );
    }

    function test_CannotProposeWithPastDeadline() public {
        vm.prank(deployer);
        vm.expectRevert(HogIndustryPolicyRegistry.InvalidDeadline.selector);
        registry.proposeAction(
            uint8(HogIndustryPolicyRegistry.PolicyKind.IMPORT_PAUSE), "Pause imports", 60, 0, block.timestamp - 1
        );
    }

    function test_CannotProposeInvalidKind() public {
        vm.prank(deployer);
        vm.expectRevert(HogIndustryPolicyRegistry.InvalidPolicyKind.selector);
        registry.proposeAction(99, "Invalid", 1, 0, block.timestamp + DEADLINE);
    }

    // ------------------------------------------------------------------
    // Commit
    // ------------------------------------------------------------------

    function test_CommitAction() public {
        uint256 id = _propose(HogIndustryPolicyRegistry.PolicyKind.IMPORT_PAUSE, 60, 0);

        vm.prank(deployer);
        registry.commitAction(id);

        HogIndustryPolicyRegistry.PolicyAction memory action = registry.getAction(id);
        assertEq(uint8(action.status), uint8(HogIndustryPolicyRegistry.PolicyStatus.COMMITTED));
        assertGt(action.committedAt, 0);
    }

    function test_OnlyAdminCanCommit() public {
        uint256 id = _propose(HogIndustryPolicyRegistry.PolicyKind.IMPORT_PAUSE, 60, 0);

        vm.prank(attacker);
        vm.expectRevert(HogIndustryPolicyRegistry.Unauthorized.selector);
        registry.commitAction(id);
    }

    function test_CannotCommitTwice() public {
        uint256 id = _propose(HogIndustryPolicyRegistry.PolicyKind.IMPORT_PAUSE, 60, 0);

        vm.startPrank(deployer);
        registry.commitAction(id);
        vm.expectRevert(HogIndustryPolicyRegistry.InvalidStatus.selector);
        registry.commitAction(id);
        vm.stopPrank();
    }

    // ------------------------------------------------------------------
    // Enforce
    // ------------------------------------------------------------------

    function test_EnforceAction() public {
        uint256 id = _committed(HogIndustryPolicyRegistry.PolicyKind.FLOOR_PRICE, 21000, 0);
        bytes32 evidence = keccak256("DA-EO-2026-001");

        vm.prank(deployer);
        registry.enforceAction(id, evidence);

        HogIndustryPolicyRegistry.PolicyAction memory action = registry.getAction(id);
        assertEq(uint8(action.status), uint8(HogIndustryPolicyRegistry.PolicyStatus.ENFORCED));
        assertEq(action.evidenceHash, evidence);
        assertGt(action.enforcedAt, 0);
    }

    function test_OnlyAdminCanEnforce() public {
        uint256 id = _committed(HogIndustryPolicyRegistry.PolicyKind.FLOOR_PRICE, 21000, 0);

        vm.prank(attacker);
        vm.expectRevert(HogIndustryPolicyRegistry.Unauthorized.selector);
        registry.enforceAction(id, keccak256("evidence"));
    }

    function test_CannotEnforceWithZeroEvidenceHash() public {
        uint256 id = _committed(HogIndustryPolicyRegistry.PolicyKind.FLOOR_PRICE, 21000, 0);

        vm.prank(deployer);
        vm.expectRevert(HogIndustryPolicyRegistry.InvalidEvidenceHash.selector);
        registry.enforceAction(id, bytes32(0));
    }

    function test_CannotEnforceAfterDeadline() public {
        uint256 id = _committed(HogIndustryPolicyRegistry.PolicyKind.FLOOR_PRICE, 21000, 0);

        vm.warp(block.timestamp + DEADLINE + 1);

        vm.prank(deployer);
        vm.expectRevert(HogIndustryPolicyRegistry.EnforceAfterDeadline.selector);
        registry.enforceAction(id, keccak256("late evidence"));
    }

    // ------------------------------------------------------------------
    // Violations (public accountability)
    // ------------------------------------------------------------------

    function test_AnyoneCanMarkViolatedAfterDeadline() public {
        uint256 id = _committed(HogIndustryPolicyRegistry.PolicyKind.COLD_STORAGE_FREEZE, 0, 0);

        vm.warp(block.timestamp + DEADLINE + 1);

        vm.prank(attacker); // kahit sino sa publiko
        registry.markViolated(id);

        HogIndustryPolicyRegistry.PolicyAction memory action = registry.getAction(id);
        assertEq(uint8(action.status), uint8(HogIndustryPolicyRegistry.PolicyStatus.VIOLATED));
    }

    function test_CannotMarkViolatedBeforeDeadline() public {
        uint256 id = _committed(HogIndustryPolicyRegistry.PolicyKind.COLD_STORAGE_FREEZE, 0, 0);

        vm.prank(attacker);
        vm.expectRevert(HogIndustryPolicyRegistry.InvalidDeadline.selector);
        registry.markViolated(id);
    }

    function test_CannotMarkViolatedEnforcedAction() public {
        uint256 id = _committed(HogIndustryPolicyRegistry.PolicyKind.COLD_STORAGE_FREEZE, 0, 0);

        vm.prank(deployer);
        registry.enforceAction(id, keccak256("evidence"));

        vm.warp(block.timestamp + DEADLINE + 1);

        vm.prank(attacker);
        vm.expectRevert(HogIndustryPolicyRegistry.InvalidStatus.selector);
        registry.markViolated(id);
    }

    // ------------------------------------------------------------------
    // Withdraw
    // ------------------------------------------------------------------

    function test_FederationCanWithdrawProposed() public {
        uint256 id = _propose(HogIndustryPolicyRegistry.PolicyKind.MDM_RESTRICTION, 0, 0);

        vm.prank(deployer);
        registry.withdrawAction(id);

        HogIndustryPolicyRegistry.PolicyAction memory action = registry.getAction(id);
        assertEq(uint8(action.status), uint8(HogIndustryPolicyRegistry.PolicyStatus.WITHDRAWN));
    }

    function test_CannotWithdrawCommittedAction() public {
        uint256 id = _committed(HogIndustryPolicyRegistry.PolicyKind.MDM_RESTRICTION, 0, 0);

        vm.prank(deployer);
        vm.expectRevert(HogIndustryPolicyRegistry.InvalidStatus.selector);
        registry.withdrawAction(id);
    }

    // ------------------------------------------------------------------
    // Farmgate price monitoring
    // ------------------------------------------------------------------

    function test_RecordFarmgatePrice() public {
        vm.prank(deployer);
        registry.recordFarmgatePrice(21000);

        HogIndustryPolicyRegistry.FarmgateReading memory reading = registry.latestFarmgatePrice();
        assertEq(reading.priceCentavosPerKg, 21000);
        assertEq(reading.recorder, deployer);
        assertEq(registry.totalFarmgateReadings(), 1);
    }

    function test_OnlyAdminCanRecordFarmgatePrice() public {
        vm.prank(attacker);
        vm.expectRevert(HogIndustryPolicyRegistry.Unauthorized.selector);
        registry.recordFarmgatePrice(21000);
    }

    function test_CannotRecordZeroPrice() public {
        vm.prank(deployer);
        vm.expectRevert(HogIndustryPolicyRegistry.ZeroParameter.selector);
        registry.recordFarmgatePrice(0);
    }

    function test_IsBelowEnforcedFloor() public {
        uint256 id = _committed(HogIndustryPolicyRegistry.PolicyKind.FLOOR_PRICE, 21000, 0);

        vm.prank(deployer);
        registry.enforceAction(id, keccak256("floor price EO"));

        vm.prank(deployer);
        registry.recordFarmgatePrice(20000); // below P210

        (bool below, uint256 floorPrice, uint256 latest) = registry.isBelowEnforcedFloor();
        assertTrue(below);
        assertEq(floorPrice, 21000);
        assertEq(latest, 20000);
    }

    function test_IsNotBelowEnforcedFloor() public {
        uint256 id = _committed(HogIndustryPolicyRegistry.PolicyKind.FLOOR_PRICE, 21000, 0);

        vm.prank(deployer);
        registry.enforceAction(id, keccak256("floor price EO"));

        vm.prank(deployer);
        registry.recordFarmgatePrice(22000); // above P210

        (bool below,,) = registry.isBelowEnforcedFloor();
        assertFalse(below);
    }

    function test_IsBelowEnforcedFloorRevertsWithoutEnforcedFloor() public {
        vm.prank(deployer);
        registry.recordFarmgatePrice(20000);

        vm.expectRevert(HogIndustryPolicyRegistry.NoFloorPriceEnforced.selector);
        registry.isBelowEnforcedFloor();
    }

    function test_IsBelowEnforcedFloorRevertsWithoutReadings() public {
        uint256 id = _committed(HogIndustryPolicyRegistry.PolicyKind.FLOOR_PRICE, 21000, 0);

        vm.prank(deployer);
        registry.enforceAction(id, keccak256("floor price EO"));

        vm.expectRevert(HogIndustryPolicyRegistry.NoFarmgateReading.selector);
        registry.isBelowEnforcedFloor();
    }

    // ------------------------------------------------------------------
    // Views / edge cases
    // ------------------------------------------------------------------

    function test_GetActionRevertsForUnknownId() public {
        vm.expectRevert(HogIndustryPolicyRegistry.ActionNotFound.selector);
        registry.getAction(999);
    }

    function test_TotalActionsStartsAtZero() public view {
        assertEq(registry.totalActions(), 0);
        assertEq(registry.totalFarmgateReadings(), 0);
    }

    // ------------------------------------------------------------------
    // Helpers
    // ------------------------------------------------------------------

    function _propose(HogIndustryPolicyRegistry.PolicyKind kind, uint256 primaryParam, uint256 secondaryParam)
        private
        returns (uint256 id)
    {
        vm.prank(deployer);
        id = registry.proposeAction(
            uint8(kind), "Test action", primaryParam, secondaryParam, block.timestamp + DEADLINE
        );
    }

    function _committed(HogIndustryPolicyRegistry.PolicyKind kind, uint256 primaryParam, uint256 secondaryParam)
        private
        returns (uint256 id)
    {
        id = _propose(kind, primaryParam, secondaryParam);
        vm.prank(deployer);
        registry.commitAction(id);
    }
}
