// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../contracts/LaborEquilibrium.sol";

contract LaborEquilibriumTest is Test {
    LaborEquilibrium public labor;
    address public megaCorp = address(0x111);
    address public sme = address(0x222);

    function setUp() public {
        labor = new LaborEquilibrium(); // 0 arguments expected now!
        labor.registerCompany(megaCorp, LaborEquilibrium.CompanyTier.TIER1_MEGACORP, 500);
        labor.registerCompany(sme, LaborEquilibrium.CompanyTier.TIER3_SME, 500);
    }

    function testSMEProtectionAndWageHike() public {
        // Step 1: Execute a Wage Hike of 100 for the SME
        labor.executeWageHike(sme, 100);
        
        // Step 2: Verify the logic (Returns: tier, isAudited, baseWage, taxCredits)
        (,,, uint256 smeTaxCredits) = labor.companies(sme);
        assertEq(smeTaxCredits, 100, "SME did not receive load-balancing tax credits!");
        
        // Step 3: Execute a Wage Hike for MegaCorp, verify they get NO tax credits
        labor.executeWageHike(megaCorp, 100);
        (,,, uint256 megaTaxCredits) = labor.companies(megaCorp);
        assertEq(megaTaxCredits, 0, "MegaCorp should NOT receive tax credits");
    }
}
