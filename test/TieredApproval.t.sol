// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/TieredApproval.sol";

contract TieredApprovalHarness is TieredApproval {
    function setComposition(uint256 b, uint256 s) external { _setComposition(b, s); }

    function resolve(
        bytes32 actionId,
        Tier tier,
        uint256 boardFor,
        uint256 stockholderFor,
        address actor,
        uint256 actorBoard,
        uint256 actorStockholder
    ) external {
        _resolveAction(actionId, tier, boardFor, stockholderFor, actor, actorBoard, actorStockholder);
    }
}

contract TieredApprovalTest is Test {
    TieredApprovalHarness t;

    function setUp() public {
        t = new TieredApprovalHarness();
        t.setComposition(3, 10000);
    }

    function testDefaults() public {
        // boardTotal = 3
        assertEq(t.requiredBoard(TieredApproval.Tier.MAJORITY), 2);       // >50% of 3
        assertEq(t.requiredBoard(TieredApproval.Tier.SUPERMAJORITY), 2);  // >=2/3 of 3
        assertEq(t.requiredBoard(TieredApproval.Tier.UNANIMOUS), 3);      // all

        // stockholderTotal = 10000
        assertEq(t.requiredStockholder(TieredApproval.Tier.MAJORITY), 5001);
        assertEq(t.requiredStockholder(TieredApproval.Tier.SUPERMAJORITY), 6667);
        assertEq(t.requiredStockholder(TieredApproval.Tier.UNANIMOUS), 10000);
    }

    function testMajorityRequiresBoth() public {
        assertFalse(t.meetsThreshold(TieredApproval.Tier.MAJORITY, 2, 4000));
        assertFalse(t.meetsThreshold(TieredApproval.Tier.MAJORITY, 1, 9000));
        assertTrue(t.meetsThreshold(TieredApproval.Tier.MAJORITY, 2, 5001));
    }

    function testSupermajorityExactTwoThirds() public {
        assertTrue(t.meetsThreshold(TieredApproval.Tier.SUPERMAJORITY, 2, 6667));
        assertFalse(t.meetsThreshold(TieredApproval.Tier.SUPERMAJORITY, 1, 10000));
    }

    function testSoleAuthorityFlagged() public {
        address soloOp = address(0xA11CE);
        bytes32 id = keccak256("act-1");

        t.resolve(
            id,
            TieredApproval.Tier.SUPERMAJORITY,
            3, 9000, soloOp,
            3, 9000
        );

        TieredApproval.Action memory a = t.getAction(id);
        assertEq(uint8(a.required), uint8(TieredApproval.Tier.SUPERMAJORITY));
        assertEq(a.soleActor, soloOp, "soloActor not flagged");
        assertTrue(a.resolved);
    }

    function testCoalitionNotFlaggedAsSole() public {
        address a1 = address(0xA1);
        bytes32 id = keccak256("act-2");

        t.resolve(
            id,
            TieredApproval.Tier.SUPERMAJORITY,
            2, 7000, a1,
            1, 3500
        );

        assertEq(t.getAction(id).soleActor, address(0));
    }

    function testCannotResolveTwice() public {
        bytes32 id = keccak256("act-3");
        t.resolve(id, TieredApproval.Tier.OPERATOR, 0, 0, address(this), 0, 0);

        vm.expectRevert("Already resolved");
        t.resolve(id, TieredApproval.Tier.OPERATOR, 0, 0, address(this), 0, 0);
    }

    function testCannotResolveWithoutThreshold() public {
        bytes32 id = keccak256("act-4");
        vm.expectRevert("Tier not achieved");
        t.resolve(id, TieredApproval.Tier.SUPERMAJORITY, 1, 1000, address(this), 1, 1000);
    }

    function testUnanimousRequiresEveryone() public {
        assertFalse(t.meetsThreshold(TieredApproval.Tier.UNANIMOUS, 3, 9999));
        assertTrue(t.meetsThreshold(TieredApproval.Tier.UNANIMOUS, 3, 10000));
    }
}
