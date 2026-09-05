// SPDX-License-Identifier: PUBLIC-MATTERS-V1
pragma solidity 0.8.35;

import "forge-std/Test.sol";
import "../src/IndustrializationLedger.sol";
import "../src/MemoryAuction.sol";

contract IntegrationLedgerAuctionTest is Test {
    IndustrializationLedger ledger;
    MemoryAuction auction;

    address admin = address(0xABCD);
    address agent = address(0x1234);

    function setUp() public {
        vm.startPrank(admin);
        ledger = new IndustrializationLedger();
        auction = new MemoryAuction();
        vm.stopPrank();
    }

    function test_ProjectAndAuctionDecision() public {
        // Admin registers a project
        vm.startPrank(admin);
        ledger.registerProject(
            "Steel Plant",
            "Manufacturing",
            1000000,
            100, // duration in blocks
            "ipfs://QmProject"
        );
        vm.stopPrank();

        // Agent creates an NPC with actions
        uint256 agentId = auction.createAgent("NPC Agent");
        auction.addAction(agentId, "Approve Project", 10);
        auction.addAction(agentId, "Reject Project", 5);

        // Record a positive memory (e.g., past project success)
        auction.recordMemory(agentId, "Past project boosted economy", 3);

        // NPC makes a decision
        string memory decision = auction.makeDecision(agentId);

        // Assert that the chosen action is "Approve Project"
        assertEq(decision, "Approve Project");
    }
}
