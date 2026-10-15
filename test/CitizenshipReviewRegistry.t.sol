// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/OperatorPrivileges.sol";
import "../src/CitizenshipReviewRegistry.sol";

contract CitizenshipReviewRegistryTest is Test {
    OperatorPrivileges privileges;
    CitizenshipReviewRegistry registry;

    address filer = vm.addr(1);
    address reviewer = vm.addr(2);
    address stranger = vm.addr(3);

    bytes32 constant SUBJECT = keccak256("subject-hash-1");
    bytes32 constant GROUNDS = keccak256("grounds-fraud");

    function setUp() public {
        privileges = new OperatorPrivileges();
        registry = new CitizenshipReviewRegistry(address(privileges));
        privileges.addOperator(filer);
        privileges.addOperator(reviewer);
    }

    function _file() internal returns (bytes32) {
        vm.prank(filer);
        return registry.fileReview(SUBJECT, GROUNDS);
    }

    function testFileReview() public {
        bytes32 id = _file();
        CitizenshipReviewRegistry.Review memory r = registry.getReview(id);
        assertEq(r.filer, filer);
        assertEq(uint8(r.state), uint8(CitizenshipReviewRegistry.ReviewState.FILED));
        assertEq(registry.totalFiled(), 1);
    }

    function testStrangerCannotFile() public {
        vm.prank(stranger);
        vm.expectRevert("Not authorized operator");
        registry.fileReview(SUBJECT, GROUNDS);
    }

    function testCannotResolveWithoutNotice() public {
        bytes32 id = _file();
        // Skip straight to resolve — should fail because state is FILED
        vm.prank(filer);
        vm.expectRevert("Not under review");
        registry.resolve(id, keccak256("outcome"));
    }

    function testServeNotice() public {
        bytes32 id = _file();
        vm.prank(filer);
        registry.serveNotice(id);

        CitizenshipReviewRegistry.Review memory r = registry.getReview(id);
        assertEq(uint8(r.state), uint8(CitizenshipReviewRegistry.ReviewState.APPEAL_WINDOW_OPEN));
        assertEq(r.appealDeadline, block.timestamp + registry.appealWindow());
    }

    function testCannotServeNoticeTwice() public {
        bytes32 id = _file();
        vm.prank(filer);
        registry.serveNotice(id);
        vm.prank(filer);
        vm.expectRevert("Not in FILED");
        registry.serveNotice(id);
    }

    function testAppealWithinWindow() public {
        bytes32 id = _file();
        vm.prank(filer);
        registry.serveNotice(id);

        vm.prank(stranger);
        registry.fileAppeal(id);

        CitizenshipReviewRegistry.Review memory r = registry.getReview(id);
        assertEq(uint8(r.state), uint8(CitizenshipReviewRegistry.ReviewState.APPEAL_FILED));
    }

    function testCannotAppealAfterWindow() public {
        bytes32 id = _file();
        vm.prank(filer);
        registry.serveNotice(id);

        // Jump past appeal window
        skip(registry.appealWindow() + 1);

        vm.prank(stranger);
        vm.expectRevert("Window expired");
        registry.fileAppeal(id);
    }

    function testAssignReviewer() public {
        bytes32 id = _file();
        vm.prank(filer);
        registry.serveNotice(id);

        vm.prank(filer);
        registry.assignReviewer(id, reviewer);

        CitizenshipReviewRegistry.Review memory r = registry.getReview(id);
        assertEq(r.independentReviewer, reviewer);
        assertEq(uint8(r.state), uint8(CitizenshipReviewRegistry.ReviewState.UNDER_REVIEW));
    }

    function testReviewerMustBeIndependent() public {
        bytes32 id = _file();
        vm.prank(filer);
        registry.serveNotice(id);

        vm.prank(filer);
        vm.expectRevert("Reviewer must be independent of filer");
        registry.assignReviewer(id, filer);
    }

    function testReviewerMustBeOperator() public {
        bytes32 id = _file();
        vm.prank(filer);
        registry.serveNotice(id);

        vm.prank(filer);
        vm.expectRevert("Reviewer must be an operator");
        registry.assignReviewer(id, stranger);
    }

    function testOnlyAssignedReviewerCanResolve() public {
        bytes32 id = _file();
        vm.prank(filer);
        registry.serveNotice(id);
        vm.prank(filer);
        registry.assignReviewer(id, reviewer);

        vm.prank(filer);
        vm.expectRevert("Only assigned reviewer");
        registry.resolve(id, keccak256("outcome"));

        vm.prank(reviewer);
        registry.resolve(id, keccak256("outcome"));

        CitizenshipReviewRegistry.Review memory r = registry.getReview(id);
        assertEq(uint8(r.state), uint8(CitizenshipReviewRegistry.ReviewState.RESOLVED));
        assertEq(registry.totalResolved(), 1);
    }

    function testCannotCancelAfterNotice() public {
        bytes32 id = _file();
        vm.prank(filer);
        registry.serveNotice(id);

        vm.prank(filer);
        vm.expectRevert("Cannot cancel after notice");
        registry.cancelReview(id);
    }

    function testCancelBeforeNotice() public {
        bytes32 id = _file();
        vm.prank(filer);
        registry.cancelReview(id);
        assertEq(registry.totalCancelled(), 1);
    }

    function testAppealWindowSetters() public {
        vm.prank(filer);
        vm.expectRevert("appealWindow out of range");
        registry.setAppealWindow(1 hours);

        vm.prank(filer);
        registry.setAppealWindow(60 days);
        assertEq(registry.appealWindow(), 60 days);
    }
}
