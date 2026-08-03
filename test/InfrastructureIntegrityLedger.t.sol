// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../contracts/InfrastructureIntegrityLedger.sol";

contract InfrastructureIntegrityLedgerTest is Test {
    InfrastructureIntegrityLedger public iil;

    address public admin = address(this);
    address public auditor = address(0x1);

    bytes32 public bimHash = keccak256(abi.encodePacked("BIM_Blueprint_Bridge_v1"));

    function setUp() public {
        iil = new InfrastructureIntegrityLedger();
    }

    function test_RegisterProjectAndAuditMilestone() public {
        string[] memory desc = new string[](2);
        desc[0] = "Foundation Inspection";
        desc[1] = "Superstructure Completion";

        uint256[] memory payouts = new uint256[](2);
        payouts[0] = 500_000 ether;
        payouts[1] = 500_000 ether;

        // Admin registers project
        uint256 projectId = iil.registerProject("Cagayan River Bridge Project", bimHash, desc, payouts);
        assertEq(projectId, 1);

        // Auditor submits audit signature for milestone 0
        vm.prank(auditor);
        iil.submitAuditSignature(projectId, 0);

        // Admin approves release
        iil.approveMilestoneRelease(projectId, 0);

        (string memory name, bytes32 hash, uint256 total, uint256 released, uint256 completed, bool isCompleted) = iil.projects(projectId);
        assertEq(name, "Cagayan River Bridge Project");
        assertEq(hash, bimHash);
        assertEq(total, 1_000_000 ether);
        assertEq(released, 500_000 ether);
        assertEq(completed, 1);
        assertFalse(isCompleted);
    }
}
