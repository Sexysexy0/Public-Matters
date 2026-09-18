// SPDX-License-Identifier: PUBLIC-MATTERS-V1
pragma solidity 0.8.35;

import "forge-std/Test.sol";
import "../src/IndustrializationLedger.sol";
import "../src/MemoryAuction.sol";

contract GovernanceStressTest is Test {
    IndustrializationLedger ledger;
    MemoryAuction auction;

    address admin = address(0xABCD);

    function setUp() public {
        vm.startPrank(admin);
        ledger = new IndustrializationLedger();
        auction = new MemoryAuction();
        vm.stopPrank();
    }

    function test_DozenAgentsDozenProjects() public {
        // Register 12 projects
        vm.startPrank(admin);
        for (uint256 i = 0; i < 12; i++) {
            ledger.registerProject(
                string(abi.encodePacked("Project ", vm.toString(i))),
                "Sector",
                100000 * (i + 1),
                50, // duration in blocks
                "ipfs://QmProject"
            );
        }
        vm.stopPrank();

        // Create 12 agents
        uint256[] memory agents = new uint256[](12);
        for (uint256 i = 0; i < 12; i++) {
            agents[i] = auction.createAgent(string(abi.encodePacked("Agent ", vm.toString(i))));
            auction.addAction(agents[i], "Approve", 10 + i);
            auction.addAction(agents[i], "Reject", 5);

            // Casting to int256 is safe because i % 3 in {0,1,2}
            // forge-lint: disable-next-line(unsafe-typecast)
            auction.recordMemory(agents[i], "Past success boosted trust", int256(i % 3));
        }

        // Each agent makes a decision
        for (uint256 i = 0; i < 12; i++) {
            string memory decision = auction.makeDecision(agents[i]);
            assertEq(decision, "Approve"); // all agents lean positive
        }
    }
}
