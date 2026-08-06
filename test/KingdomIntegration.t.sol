// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../contracts/FamilyOfficeRegistry.sol";
import "../contracts/MultiSigEscrowVault.sol";
import "../contracts/TokenizedTreatyBase.sol";
import "../contracts/ProjectMilestoneEscrow.sol";
import "../contracts/DisputeResolutionArbitration.sol";
import "../contracts/AnchorGovernanceVault.sol";

// Mock contract to deploy the abstract Treaty Base
contract MockTreaty is TokenizedTreatyBase {}

contract KingdomIntegrationTest is Test {
    FamilyOfficeRegistry public registry;
    MultiSigEscrowVault public vault;
    MockTreaty public treatyBase; // Using MockTreaty here
    ProjectMilestoneEscrow public escrow;
    DisputeResolutionArbitration public arbitration;
    AnchorGovernanceVault public anchor;

    address public owner = address(this);
    address public partner1 = makeAddr("partner1");
    address public partner2 = makeAddr("partner2");

    function setUp() public {
        // 1. Deploy Registry
        registry = new FamilyOfficeRegistry();

        // 2. Deploy Vault (2-out-of-2 MultiSig for test)
        address[] memory signers = new address[](2);
        signers[0] = partner1;
        signers[1] = partner2;
        vault = new MultiSigEscrowVault(signers, 2);
        vm.deal(address(vault), 100 ether); // Fund the vault

        // 3. Deploy Treaty Base (Using MockTreaty)
        treatyBase = new MockTreaty();

        // 4. Deploy Escrow (Link to Vault)
        escrow = new ProjectMilestoneEscrow(address(vault));
        vault.addSigner(address(escrow));

        // 5. Deploy Arbitration
        arbitration = new DisputeResolutionArbitration();

        // 6. Deploy Anchor (Command Center)
        anchor = new AnchorGovernanceVault();

        // 7. WIRE THEM TOGETHER via the Anchor
        anchor.setCoreContracts(
            address(registry),
            address(vault),
            address(treatyBase),
            address(escrow),
            address(arbitration)
        );
    }

    function test_FullKingdomWorkflow() public {
        // --- Step 1: Register a Family Office ---
        bytes32 hash = keccak256(abi.encodePacked("PwC-Test-Doc"));
        registry.registerOffice("PwC Manila Family Office", FamilyOfficeRegistry.Jurisdiction.APAC, hash);

        // --- Step 2: Create a Treaty ---
        bytes32 treatyHash = keccak256(abi.encodePacked("PH-USA-Web3-Treaty"));
        uint256 treatyId = treatyBase.createTreaty("PH-USA Blockchain Accord", "Philippines, USA", treatyHash, block.timestamp + 365 days);
        
        // --- Step 3: Create a Project linked to the Treaty ---
        string[] memory descs = new string[](2);
        descs[0] = "Phase 1 - Infrastructure";
        descs[1] = "Phase 2 - Deployment";

        uint256[] memory amounts = new uint256[](2);
        amounts[0] = 10 ether;
        amounts[1] = 20 ether;

        address payable recipient = payable(makeAddr("project_recipient"));
        uint256 projectId = escrow.createProject(treatyId, recipient, descs, amounts);

        // --- Step 4: Complete a Milestone (Automated Funding Request) ---
        escrow.completeMilestone(projectId, 0); 
        
        // Verify the Vault now has 1 transaction queued
        assertEq(vault.transactionCount(), 1);

        // --- Step 5: Raise and Resolve a Dispute ---
        bytes32 evidence = keccak256(abi.encodePacked("Missing Deliverables"));
        uint256 disputeId = arbitration.raiseDispute(treatyId, partner1, evidence);
        arbitration.resolveDispute(disputeId, true);
        
        // Fixed: Use struct instead of tuple unpacking
        DisputeResolutionArbitration.Dispute memory dispute = arbitration.getDispute(disputeId);
        assertEq(uint8(dispute.status), uint8(DisputeResolutionArbitration.DisputeStatus.RESOLVED));

        // --- Step 6: Emergency Pause via Anchor ---
        anchor.pause();
        ( , , , , , bool isPaused) = anchor.getSystemStatus();
        assertTrue(isPaused);

        // --- Step 7: Unpause ---
        anchor.unpause();
        ( , , , , , isPaused) = anchor.getSystemStatus();
        assertFalse(isPaused);
    }
}
