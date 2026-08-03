// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../contracts/AncestralDomainSovereignty.sol";

contract AncestralDomainSovereigntyTest is Test {
    AncestralDomainSovereignty public ads;

    address public admin = address(this);
    address public elder1 = address(0x1);
    address public elder2 = address(0x2);
    address public elder3 = address(0x3);
    address public developer = address(0x4);

    function setUp() public {
        ads = new AncestralDomainSovereignty();

        address[] memory elders = new address[](3);
        elders[0] = elder1;
        elders[1] = elder2;
        elders[2] = elder3;

        // Register Zone 1 with 2-of-3 required signatures for FPIC
        ads.registerAncestralZone("Sierra Madre Ancestral Domain", "GeoHash-SM-001", elders, 2);
    }

    function test_SubmitAndApproveProposalFPIC() public {
        vm.prank(developer);
        uint256 proposalId = ads.submitProjectProposal(1, "MegaCorp Mining", "https://proposal.uri");

        // First elder votes approval
        vm.prank(elder1);
        ads.castFPICVote(proposalId, true);

        (, , , uint256 approvalCount, bool isApproved, bool isVetoed) = ads.proposals(proposalId);
        assertEq(approvalCount, 1);
        assertFalse(isApproved);
        assertFalse(isVetoed);

        // Second elder votes approval -> reaches threshold (2 signatures)
        vm.prank(elder2);
        ads.castFPICVote(proposalId, true);

        (, , , approvalCount, isApproved, isVetoed) = ads.proposals(proposalId);
        assertEq(approvalCount, 2);
        assertTrue(isApproved);
        assertFalse(isVetoed);
    }

    function test_ElderVetoBlocksProposal() public {
        vm.prank(developer);
        uint256 proposalId = ads.submitProjectProposal(1, "MegaCorp Mining", "https://proposal.uri");

        // Elder 1 exercises Veto Power
        vm.prank(elder1);
        ads.castFPICVote(proposalId, false);

        (, , , , bool isApproved, bool isVetoed) = ads.proposals(proposalId);
        assertFalse(isApproved);
        assertTrue(isVetoed);
    }
}
