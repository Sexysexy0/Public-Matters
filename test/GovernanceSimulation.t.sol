// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../contracts/SammaCodex.sol";
import "../contracts/CivicDAO.sol";
import "../contracts/ValidatorRegistry.sol";

contract GovernanceSimulation is Test {
    SammaCodex samma;
    CivicDAO civic;
    ValidatorRegistry registry;

    function setUp() public {
        samma = new SammaCodex(address(this));
        civic = new CivicDAO(address(samma));
        registry = new ValidatorRegistry();
    }

    function testPrincipleAndProposalFlow() public {
        // Declare principle
        samma.declarePrinciple("No Extortion", "Transparent accusations only");
        assertTrue(samma.isActive(1));

        // Create proposal linked to principle
        civic.createProposal("Ban phantom accusations", 1);
        civic.vote(1, true);
        civic.vote(1, true);
        civic.executeProposal(1);

        // Register validator
        registry.registerValidator(100);
        assertEq(registry.validators(address(this)).stake, 100);

        // Slash validator for extortion-style behaviour
        registry.slashValidator(address(this), 50, "Attempted phantom accusation");
        assertEq(registry.validators(address(this)).stake, 50);
    }
}
