// SPDX-License-Identifier: PUBLIC-MATTERS-V1
pragma solidity 0.8.35;

import "forge-std/Test.sol";
import "../src/IndustrializationLedger.sol";
import "../src/MemoryAuction.sol";

contract GovernanceBundleIntegrationTest is Test {
    IndustrializationLedger ledger;
    MemoryAuction auction;

    address admin = address(0xABCD);

    function setUp() public {
        vm.startPrank(admin);
        ledger = new IndustrializationLedger();
        auction = new MemoryAuction();
        vm.stopPrank();
    }

    function test_MultiAgentMultiProjectDecision() public {
        // Register two industrialization projects
        vm.startPrank(admin);
        ledger.registerProject("Steel Plant", "Manufacturing", 1000000, 100, "ipfs://QmSteel");
        ledger.registerProject("Solar Farm", "Energy", 500000, 100, "ipfs://QmSolar");
        vm.stopPrank();

        // Create two agents
        uint256 agentA = auction.createAgent("Agent A");
        uint256 agentB = auction.createAgent("Agent B");

        // Add actions for both agents
        auction.addAction(agentA, "Approve Steel Plant", 10);
        auction.addAction(agentA, "Reject Steel Plant", 5);
        auction.addAction(agentB, "Approve Solar Farm", 8);
        auction.addAction(agentB, "Reject Solar Farm", 6);

        // Record memories
        auction.recordMemory(agentA, "Past steel project boosted jobs", 3);
        auction.recordMemory(agentB, "Past solar project reduced costs", 4);

        // Agents make decisions
        string memory decisionA = auction.makeDecision(agentA);
        string memory decisionB = auction.makeDecision(agentB);

        // Assertions
        assertEq(decisionA, "Approve Steel Plant");
        assertEq(decisionB, "Approve Solar Farm");
    }
}
