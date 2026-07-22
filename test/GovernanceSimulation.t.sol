// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../contracts/SammaCodex.sol";
import "../contracts/CivicDAO.sol";

contract GovernanceSimulation is Test {
    SammaCodex samma;
    CivicDAO civic;

    function setUp() public {
        samma = new SammaCodex(address(this));
        civic = new CivicDAO(address(samma));
    }

    function testPrincipleAndProposalFlow() public {
        samma.declarePrinciple("No Extortion", "Accusations must be transparent and detailed");
        assertTrue(samma.isActive(1));

        civic.createProposal("Ban phantom accusations", 1);
        civic.vote(1, true);

        // simulate second voter to avoid "Already voted" error
        vm.prank(address(0xBEEF));
        civic.vote(1, true);

        civic.executeProposal(1);
    }
}
