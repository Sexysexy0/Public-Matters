// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import {CandidateCommitmentRegistry} from "../../src/candidate-commitments/CandidateCommitmentRegistry.sol";

contract CandidateCommitmentRegistryTest is Test {
    CandidateCommitmentRegistry registry;
    address deployer = makeAddr("deployer");
    bytes32 evidence = keccak256("evidence");

    function setUp() public {
        vm.prank(deployer);
        registry = new CandidateCommitmentRegistry();
    }

    function test_DeployerBecomesAdminAndFederation() public view {
        assertEq(registry.admin(), deployer);
        assertEq(registry.federation(), deployer);
        assertEq(registry.totalCommitments(), 0);
    }

    function test_ProposeTariffCommitment() public {
        vm.prank(deployer);
        uint256 id = registry.proposeCommitment(
            CandidateCommitmentRegistry.CommitmentKind.TARIFF_2018_BASELINE,
            "Restore tariffs to 2018 levels",
            2018,
            2018,
            evidence,
            block.timestamp + 180 days
        );

        CandidateCommitmentRegistry.Commitment memory c = registry.getCommitment(id);
        assertEq(uint8(c.status), uint8(CandidateCommitmentRegistry.Status.PROPOSED));
        assertEq(c.baselineValue, 2018);
        assertEq(registry.totalCommitments(), 1);
    }

    function test_ProposeDieselCommitment() public {
        vm.prank(deployer);
        uint256 id = registry.proposeCommitment(
            CandidateCommitmentRegistry.CommitmentKind.DIESEL_50_PERCENT,
            "Reduce diesel to $1.75/gal (50% off $3.50 baseline)",
            350,
            175,
            evidence,
            block.timestamp + 365 days
        );

        CandidateCommitmentRegistry.Commitment memory c = registry.getCommitment(id);
        assertEq(c.baselineValue, 350);
        assertEq(c.targetValue, 175);
        assertEq(registry.totalCommitments(), 1);
    }

    function test_CommitAndEnforce() public {
        vm.startPrank(deployer);
        uint256 id = registry.proposeCommitment(
            CandidateCommitmentRegistry.CommitmentKind.DIESEL_50_PERCENT,
            "diesel",
            350,
            175,
            evidence,
            block.timestamp + 365 days
        );
        registry.commitCommitment(id);
        registry.enforceCommitment(id, evidence);
        vm.stopPrank();

        CandidateCommitmentRegistry.Commitment memory c = registry.getCommitment(id);
        assertEq(uint8(c.status), uint8(CandidateCommitmentRegistry.Status.ENFORCED));
    }

    function test_MarkViolated() public {
        vm.prank(deployer);
        uint256 id = registry.proposeCommitment(
            CandidateCommitmentRegistry.CommitmentKind.TARIFF_2018_BASELINE,
            "tariffs",
            2018,
            2018,
            evidence,
            block.timestamp + 1 days
        );

        vm.warp(block.timestamp + 2 days);
        registry.markViolated(id);

        CandidateCommitmentRegistry.Commitment memory c = registry.getCommitment(id);
        assertEq(uint8(c.status), uint8(CandidateCommitmentRegistry.Status.VIOLATED));
    }

    function test_OnlyFederationCanPropose() public {
        vm.prank(makeAddr("attacker"));
        vm.expectRevert(CandidateCommitmentRegistry.OnlyFederation.selector);
        registry.proposeCommitment(
            CandidateCommitmentRegistry.CommitmentKind.TARIFF_2018_BASELINE,
            "x",
            2018,
            2018,
            evidence,
            block.timestamp + 1 days
        );
    }

    function test_OnlyAdminCanCommit() public {
        vm.prank(deployer);
        uint256 id = registry.proposeCommitment(
            CandidateCommitmentRegistry.CommitmentKind.TARIFF_2018_BASELINE,
            "x",
            2018,
            2018,
            evidence,
            block.timestamp + 1 days
        );

        vm.prank(makeAddr("attacker"));
        vm.expectRevert(CandidateCommitmentRegistry.OnlyAdmin.selector);
        registry.commitCommitment(id);
    }

    function test_InvalidEvidenceReverts() public {
        vm.prank(deployer);
        vm.expectRevert(CandidateCommitmentRegistry.InvalidEvidence.selector);
        registry.proposeCommitment(
            CandidateCommitmentRegistry.CommitmentKind.TARIFF_2018_BASELINE,
            "x",
            2018,
            2018,
            bytes32(0),
            block.timestamp + 1 days
        );
    }

    function test_GetCommitmentRevertsForUnknownId() public {
        vm.expectRevert(CandidateCommitmentRegistry.UnknownCommitment.selector);
        registry.getCommitment(99);
    }
}
