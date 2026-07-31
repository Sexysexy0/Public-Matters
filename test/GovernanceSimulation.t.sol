// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../contracts/CivicDAO.sol";
import "../contracts/SammaCodex.sol";

contract GovernanceSimulation is Test {
    CivicDAO public civic;
    SammaCodex public samma;

    function setUp() public {
        samma = new SammaCodex();
        civic = new CivicDAO(address(samma));
    }

    function testPrincipleAndProposalFlow() public {
        samma.declarePrinciple("No Extortion", "Accusations must be transparent and detailed");
        civic.createProposal("Ban phantom accusations", 1);

        address voter1 = address(0xA11CE);
        address voter2 = address(0xB0B);

        vm.prank(voter1);
        civic.vote(1, true);

        vm.prank(voter2);
        civic.vote(1, true);

        civic.executeProposal(1);
        
        (, , , uint256 votesFor, , bool executed) = civic.proposals(1);
        assertEq(votesFor, 2);
        assertTrue(executed);
    }

    function testCannotVoteOnNonExistentProposal() public {
        vm.expectRevert("Proposal does not exist");
        civic.vote(999, true);
    }

    function testUnauthorizedAddressCannotExecuteProposal() public {
        samma.declarePrinciple("No Extortion", "Transparent accusations only");
        civic.createProposal("Ban phantom accusations", 1);

        vm.prank(address(0xBEEF));
        vm.expectRevert("Not authorized");
        civic.executeProposal(1);
    }
}
