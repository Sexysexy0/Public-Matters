// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../contracts/ClimateAdaptationFinance.sol";

contract ClimateAdaptationFinanceTest is Test {
    ClimateAdaptationFinance climate;
    address admin = address(0xABCD);
    address project = address(0x1234);

    function setUp() public {
        vm.prank(admin);
        climate = new ClimateAdaptationFinance();
    }

    function testFundProject() public {
        vm.prank(admin);
        climate.fundProject(project, 1000);
        assertEq(climate.getFunds(project), 1000);
    }

    function testMultipleFunding() public {
        vm.startPrank(admin);
        climate.fundProject(project, 500);
        climate.fundProject(project, 700);
        vm.stopPrank();
        assertEq(climate.getFunds(project), 1200);
    }
}
