// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/OperatorPrivileges.sol";
import "../src/CivicSovereigntyRegistry.sol";
import "../src/SocietalContributionRegistry.sol";

contract SocietalContributionRegistryTest is Test {
    OperatorPrivileges privileges;
    CivicSovereigntyRegistry civic;
    SocietalContributionRegistry contribution;

    address op = vm.addr(1);
    address citizen = vm.addr(2);
    bytes32 constant ID_HASH = keccak256("PH-ID+salt");
    bytes32 constant REGION = keccak256("Barangay-1");

    function setUp() public {
        privileges = new OperatorPrivileges();
        privileges.addOperator(op);
        
        civic = new CivicSovereigntyRegistry(address(privileges));
        contribution = new SocietalContributionRegistry(address(privileges), address(civic));
    }

    function testUnregisteredCitizenCannotEarnPoints() public {
        vm.prank(op);
        vm.expectRevert("Citizen not registered");
        contribution.recordContribution(citizen, SocietalContributionRegistry.ContributionType.CAREGIVING, 10, "Raised a child");
    }

    function testRegisteredCitizenEarnsPoints() public {
        vm.prank(citizen);
        civic.registerCitizen(ID_HASH, REGION);

        vm.prank(op);
        contribution.recordContribution(citizen, SocietalContributionRegistry.ContributionType.CAREGIVING, 10, "Raised a child");
        
        vm.prank(op);
        contribution.recordContribution(citizen, SocietalContributionRegistry.ContributionType.CIVIC_DUTY, 5, "Community cleanup");

        assertEq(contribution.getScore(citizen), 15);
        assertEq(contribution.contributionPoints(citizen, SocietalContributionRegistry.ContributionType.CAREGIVING), 10);
    }
}
