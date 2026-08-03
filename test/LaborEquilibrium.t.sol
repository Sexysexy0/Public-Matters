// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../contracts/LaborEquilibrium.sol";

contract LaborEquilibriumTest is Test {
    LaborEquilibrium public labor;
    address public architect = address(this);
    address public megaCorp = address(0x111);
    address public sme = address(0x222);

    function setUp() public {
        labor = new LaborEquilibrium();
        
        // Register a MegaCorp and an SME
        labor.registerCompany(megaCorp, LaborEquilibrium.CompanyTier.TIER1_MEGACORP, 500);
        labor.registerCompany(sme, LaborEquilibrium.CompanyTier.TIER3_SME, 500);
    }

    function testSMEProtectionAndWageHike() public {
        // Step 1: Execute a Wage Hike of 100 for the SME
        labor.executeWageHike(sme, 100);
        
        // Step 2: Verify the wage requirement went up to 600 (500 base + 100 hike)
        (,, uint256 baseWage, uint256 taxCredits) = labor.companies(sme);
        assertEq(baseWage, 600, "Wage did not increase properly");
        
        // Step 3: Verify the SME received 100 in Tax Credits to protect them from bankruptcy!
        assertEq(taxCredits, 100, "SME did not receive load-balancing tax credits!");
        
        // Step 4: Execute a Wage Hike for MegaCorp, verify they get NO tax credits
        labor.executeWageHike(megaCorp, 100);
        (,,, uint256 megaTaxCredits) = labor.companies(megaCorp);
        assertEq(megaTaxCredits, 0, "MegaCorp should NOT receive tax credits");
    }
}
