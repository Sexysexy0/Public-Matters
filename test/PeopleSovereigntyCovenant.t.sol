// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {PeopleSovereigntyCovenant} from "../src/PeopleSovereigntyCovenant.sol";
import {EndowmentGovernor} from "../src/EndowmentGovernor.sol";

contract PeopleSovereigntyCovenantTest is Test {
    PeopleSovereigntyCovenant covenant;
    EndowmentGovernor governor;
    address anchor = address(0xA1);
    address recipient = address(0xB0);

    function setUp() public {
        governor = new EndowmentGovernor(anchor);
        covenant = new PeopleSovereigntyCovenant(address(governor));

        // Authorize the covenant to trigger disbursements
        governor.setAuthorizedTrigger(address(covenant));

        // Fund the governor's pool directly
        vm.deal(address(this), 100 ether);
        (bool success, ) = address(governor).call{value: 100 ether}("");
        require(success, "funding failed");
    }

    function test_GrantPeaceSetsFlagAndDisburses() public {
        covenant.grantPeace(recipient, 10 ether);
        assertTrue(covenant.elsaAtLandoIsPeaceful());
        assertEq(recipient.balance, 10 ether);
    }

    function test_GrantFreedomSetsFlag() public {
        covenant.grantFreedom();
        assertTrue(covenant.magdaIsFree());
    }

    function test_GrantAcceptanceSetsFlag() public {
        covenant.grantAcceptance();
        assertTrue(covenant.sirenaIsAccepted());
    }

    function test_GrantHousingSetsFlagAndDisburses() public {
        covenant.grantHousing(recipient, 20 ether);
        assertTrue(covenant.walangNatiraHasHome());
        assertEq(recipient.balance, 20 ether);
    }

    function test_GrantFairLifeSetsFlag() public {
        covenant.grantFairLife();
        assertTrue(covenant.simplengTaoHasFairLife());
    }

    function test_GrantRepatriationSetsFlag() public {
        covenant.grantRepatriation();
        assertTrue(covenant.upuanHasReturned());
    }

    function test_RevertWhenNonOwnerGrantsPeace() public {
        vm.prank(address(0xDEAD));
        vm.expectRevert("Only the Architect");
        covenant.grantPeace(recipient, 1 ether);
    }

    function test_RevertWhenNonOwnerGrantsHousing() public {
        vm.prank(address(0xDEAD));
        vm.expectRevert("Only the Architect");
        covenant.grantHousing(recipient, 1 ether);
    }
}
