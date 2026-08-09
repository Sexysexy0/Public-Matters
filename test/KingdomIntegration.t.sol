// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/FamilyOfficeRegistry.sol";
import "../src/MultiSigEscrowVault.sol";
import "../src/TokenizedTreatyBase.sol";
import "../src/ProjectMilestoneEscrow.sol";
import "../src/DisputeResolutionArbitration.sol";
import "../src/AnchorGovernanceVault.sol";

contract MockTreaty is TokenizedTreatyBase {}

contract KingdomIntegrationTest is Test {
    FamilyOfficeRegistry public registry;
    MultiSigEscrowVault public vault;
    MockTreaty public treatyBase;
    ProjectMilestoneEscrow public escrow;
    DisputeResolutionArbitration public arbitration;
    AnchorGovernanceVault public anchor;

    address public owner = address(this);
    address public partner1 = makeAddr("partner1");
    address public partner2 = makeAddr("partner2");

    function setUp() public {
        registry = new FamilyOfficeRegistry();

        address[] memory signers = new address[](2);
        signers[0] = partner1;
        signers[1] = partner2;
        vault = new MultiSigEscrowVault(signers, 2);
        vm.deal(address(vault), 100 ether);

        treatyBase = new MockTreaty();
        escrow = new ProjectMilestoneEscrow(address(vault));
        // FIX: Make the escrow a signer so it can submit transactions
        vault.addSigner(address(escrow));

        arbitration = new DisputeResolutionArbitration();
        anchor = new AnchorGovernanceVault();

        anchor.setCoreContracts(
            address(registry),
            address(vault),
            address(treatyBase),
            address(escrow),
            address(arbitration), // dummy for whistleblower
            address(arbitration), // dummy for covenant
            address(arbitration), // dummy for cyber
            address(arbitration)
        );
    }

    function test_FullKingdomWorkflow() public {
        bytes32 hash = keccak256(abi.encodePacked("PwC-Test-Doc"));
        registry.registerOffice("PwC Manila Family Office", FamilyOfficeRegistry.Jurisdiction.APAC, hash);

        bytes32 treatyHash = keccak256(abi.encodePacked("PH-USA-Web3-Treaty"));
        uint256 treatyId = treatyBase.createTreaty("PH-USA Blockchain Accord", "Philippines, USA", treatyHash, block.timestamp + 365 days);

        string[] memory descs = new string[](2);
        descs[0] = "Phase 1 - Infrastructure";
        descs[1] = "Phase 2 - Deployment";
        uint256[] memory amounts = new uint256[](2);
        amounts[0] = 10 ether;
        amounts[1] = 20 ether;
        address payable recipient = payable(makeAddr("project_recipient"));
        uint256 projectId = escrow.createProject(treatyId, recipient, descs, amounts);

        escrow.completeMilestone(projectId, 0);
        assertEq(vault.transactionCount(), 1);

        bytes32 evidence = keccak256(abi.encodePacked("Missing Deliverables"));
        uint256 disputeId = arbitration.raiseDispute(treatyId, partner1, evidence);
        arbitration.resolveDispute(disputeId, true);

        DisputeResolutionArbitration.Dispute memory dispute = arbitration.getDispute(disputeId);
        assertEq(uint8(dispute.status), uint8(DisputeResolutionArbitration.DisputeStatus.RESOLVED));

        anchor.pause();
        (, , , , , , , , bool isPaused) = anchor.getSystemStatus();
        assertTrue(isPaused);

        anchor.unpause();
        (, , , , , , , , isPaused) = anchor.getSystemStatus();
        assertFalse(isPaused);
    }
}
