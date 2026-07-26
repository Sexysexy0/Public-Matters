// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../contracts/AntiBullshittingCovenant.sol";

contract AntiBullshittingCovenantTest is Test {
    AntiBullshittingCovenant covenant;
    
    address founder = address(this);
    address council1 = address(0x1);
    address council2 = address(0x2);
    address council3 = address(0x3);
    address council4 = address(0x4);
    address operator = address(0x5);
    address community = address(0x6);
    address outsider = address(0x7);

    function setUp() public {
        address[] memory initialCouncil = new address[](3);
        initialCouncil[0] = council1;
        initialCouncil[1] = council2;
        initialCouncil[2] = council3;
        
        covenant = new AntiBullshittingCovenant(initialCouncil);
    }

    // ============ Constructor Tests ============

    function test_ConstructorSetsUpCouncil() public view {
        (address memberAddr, bool active, ) = covenant.councilMembers(council1);
        assertEq(memberAddr, council1);
        assertTrue(active);

        (, bool active2, ) = covenant.councilMembers(council2);
        assertTrue(active2);

        (, bool active3, ) = covenant.councilMembers(council3);
        assertTrue(active3);

        assertEq(covenant.getActiveCouncilCount(), 3);
        assertEq(covenant.requiredApprovals(), 2);
        assertTrue(covenant.covenantActive());
    }

    function test_RevertWhenCouncilTooSmall() public {
        address[] memory smallCouncil = new address[](2);
        smallCouncil[0] = council1;
        smallCouncil[1] = council2;
        
        vm.expectRevert("Council too small");
        new AntiBullshittingCovenant(smallCouncil);
    }

    function test_RevertWhenDuplicateCouncilMember() public {
        address[] memory dupCouncil = new address[](3);
        dupCouncil[0] = council1;
        dupCouncil[1] = council1;
        dupCouncil[2] = council2;
        
        vm.expectRevert("Duplicate council member");
        new AntiBullshittingCovenant(dupCouncil);
    }

    // ============ Registration Tests ============

    function test_RegisterOperator() public {
        vm.prank(council1);
        covenant.registerOperator(operator);
        assertTrue(covenant.operators(operator));
        assertEq(covenant.truthfulnessScore(operator), 50);
    }

    function test_RevertWhenNonCouncilRegistersOperator() public {
        vm.prank(outsider);
        vm.expectRevert("Not active council member");
        covenant.registerOperator(operator);
    }

    function test_RegisterCommunity() public {
        vm.prank(council1);
        covenant.registerCommunity(community);
        assertTrue(covenant.communityMembers(community));
    }

    function test_AddCouncilMember() public {
        covenant.addCouncilMember(council4);
        
        (, bool active, ) = covenant.councilMembers(council4);
        assertTrue(active);
        assertEq(covenant.requiredApprovals(), 3);
    }

    // ============ Claim Submission Tests ============

    function test_SubmitClaim() public {
        vm.prank(council1);
        covenant.registerOperator(operator);

        vm.prank(operator);
        covenant.submitClaim("This is a test claim about economic policy");

        assertEq(covenant.claimCount(), 1);
        
        (
            uint256 id,
            address claimOperator,
            string memory content,
            ,
            AntiBullshittingCovenant.ClaimStatus status,
            ,
            ,
            ,
            ,

        ) = covenant.claims(1);

        assertEq(id, 1);
        assertEq(claimOperator, operator);
        assertEq(content, "This is a test claim about economic policy");
        assertEq(uint256(status), uint256(AntiBullshittingCovenant.ClaimStatus.Pending));
    }

    function test_RevertWhenEmptyClaim() public {
        vm.prank(council1);
        covenant.registerOperator(operator);

        vm.prank(operator);
        vm.expectRevert("Empty claim");
        covenant.submitClaim("");
    }

    function test_RevertWhenOutsiderSubmitsClaim() public {
        vm.prank(outsider);
        vm.expectRevert("Not authorized operator");
        covenant.submitClaim("Unauthorized claim");
    }

    // ============ Audit Tests ============

    function test_AuditClaimApproved() public {
        vm.prank(council1);
        covenant.registerOperator(operator);

        vm.prank(operator);
        covenant.submitClaim("Truthful claim");

        // Council1 approves
        vm.prank(council1);
        covenant.auditClaim(1, true);

        // Check partial state
        (,,,,,,,, uint256 approvalCount, ) = covenant.claims(1);
        assertEq(approvalCount, 1);
        assertFalse(covenant.hasAudited(1, council2));

        // Council2 approves - threshold reached (2 of 3)
        vm.prank(council2);
        covenant.auditClaim(1, true);

        // Claim should be resolved
        (
            ,
            ,
            ,
            ,
            AntiBullshittingCovenant.ClaimStatus status,
            bool truthful,
            ,
            ,
            ,
            

        ) = covenant.claims(1);

        assertTrue(truthful);
        assertEq(uint256(status), uint256(AntiBullshittingCovenant.ClaimStatus.Resolved));
        assertEq(covenant.truthfulClaims(operator), 1);
        assertEq(covenant.getTruthfulnessRatio(operator), 100);
    }

    function test_AuditClaimRejected() public {
        vm.prank(council1);
        covenant.registerOperator(operator);

        vm.prank(operator);
        covenant.submitClaim("Bullshit claim");

        // Council1 rejects
        vm.prank(council1);
        covenant.auditClaim(1, false);

        // Council2 rejects - threshold reached
        vm.prank(council2);
        covenant.auditClaim(1, false);

        (,,,,, bool truthful,,,, ) = covenant.claims(1);
        assertFalse(truthful);
        assertEq(covenant.getTruthfulnessRatio(operator), 0);
    }

    function test_RevertWhenDoubleAudit() public {
        vm.prank(council1);
        covenant.registerOperator(operator);

        vm.prank(operator);
        covenant.submitClaim("Claim");

        vm.startPrank(council1);
        covenant.auditClaim(1, true);
        vm.expectRevert("Already audited by you");
        covenant.auditClaim(1, true);
        vm.stopPrank();
    }

    // ============ Dissent Tests ============

    function test_LogDissent() public {
        vm.prank(council1);
        covenant.registerOperator(operator);
        vm.prank(council1);
        covenant.registerCommunity(community);

        vm.prank(operator);
        covenant.submitClaim("Vague claim about 'moving forward'");

        vm.prank(community);
        covenant.logDissent(1, AntiBullshittingCovenant.LanguagePattern.Vague, "This is hollow language");

        (,,,, AntiBullshittingCovenant.ClaimStatus status,,,,, ) = covenant.claims(1);
        assertEq(uint256(status), uint256(AntiBullshittingCovenant.ClaimStatus.Disputed));

        AntiBullshittingCovenant.Dissent[] memory dissents = covenant.getDissents(1);
        assertEq(dissents.length, 1);
        assertEq(dissents[0].member, community);
        assertEq(uint256(dissents[0].pattern), uint256(AntiBullshittingCovenant.LanguagePattern.Vague));
    }

    function test_RevertWhenDissentPeriodExpired() public {
        vm.prank(council1);
        covenant.registerOperator(operator);
        vm.prank(council1);
        covenant.registerCommunity(community);

        vm.prank(operator);
        covenant.submitClaim("Old claim");

        vm.warp(block.timestamp + 8 days);

        vm.prank(community);
        vm.expectRevert("Dissent period expired");
        covenant.logDissent(1, AntiBullshittingCovenant.LanguagePattern.Cliche, "Too late");
    }

    // ============ Pause Tests ============

    function test_PauseAndResume() public {
        // Setup operator BEFORE pausing
        vm.prank(council1);
        covenant.registerOperator(operator);

        covenant.pauseCovenant();
        assertFalse(covenant.covenantActive());

        // Should not be able to submit claims when paused
        vm.prank(operator);
        vm.expectRevert("Covenant inactive");
        covenant.submitClaim("Claim during pause");

        // Resume
        covenant.resumeCovenant();
        assertTrue(covenant.covenantActive());

        vm.prank(operator);
        covenant.submitClaim("Claim after resume");
        assertEq(covenant.claimCount(), 1);
    }

    // ============ Truthfulness Score Tests ============

    function test_TruthfulnessScoreUpdates() public {
        vm.prank(council1);
        covenant.registerOperator(operator);

        vm.startPrank(operator);
        covenant.submitClaim("Claim 1");
        covenant.submitClaim("Claim 2");
        vm.stopPrank();

        vm.prank(council1);
        covenant.auditClaim(1, true);
        vm.prank(council2);
        covenant.auditClaim(1, true);

        vm.prank(council1);
        covenant.auditClaim(2, true);
        vm.prank(council2);
        covenant.auditClaim(2, true);

        assertEq(covenant.getTruthfulnessRatio(operator), 100);
        assertEq(covenant.truthfulnessScore(operator), 100);
    }

    // ============ Edge Cases ============

    function test_ResolveDisputedClaim() public {
        vm.prank(council1);
        covenant.registerOperator(operator);
        vm.prank(council1);
        covenant.registerCommunity(community);

        vm.prank(operator);
        covenant.submitClaim("Disputed claim");

        vm.prank(community);
        covenant.logDissent(1, AntiBullshittingCovenant.LanguagePattern.Groupthink, "Tribal conformity detected");

        vm.prank(council1);
        vm.expectRevert("Deliberation ongoing");
        covenant.resolveClaim(1);

        vm.warp(block.timestamp + 8 days);

        vm.prank(council1);
        covenant.resolveClaim(1);

        (,,,, AntiBullshittingCovenant.ClaimStatus status,,,,, ) = covenant.claims(1);
        assertEq(uint256(status), uint256(AntiBullshittingCovenant.ClaimStatus.Resolved));
    }

    function test_RemoveCouncilMemberUpdatesThreshold() public {
        assertEq(covenant.requiredApprovals(), 2);

        covenant.addCouncilMember(council4);
        assertEq(covenant.requiredApprovals(), 3);

        covenant.removeCouncilMember(council4);
        assertEq(covenant.requiredApprovals(), 2);
    }

    function test_RevertWhenRemoveBelowMinCouncil() public {
        vm.expectRevert("Cannot reduce below minimum");
        covenant.removeCouncilMember(council1);
    }
}
