// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../contracts/BitMarketBudgetSanctumRouter.sol";
import "../contracts/BitMarketBlessingAutoDeploy.sol";

contract BitMarketBlessingAutoDeployTest is Test {
    BitMarketBudgetSanctumRouter router;
    BitMarketBlessingAutoDeploy deployer;

    function setUp() public {
        router = new BitMarketBudgetSanctumRouter();
        deployer = new BitMarketBlessingAutoDeploy(address(router));
    }

    function testAutoBlessingDeploysOnHighAPR() public {
        deployer.autoDeployBlessing("Bangkal Northville", "youth", 92, 2000000);
        // Expect event emission: AutoBlessingDeployed
    }

    function testAutoBlessingFailsOnLowAPR() public {
        vm.expectRevert("APR too low for auto-blessing");
        deployer.autoDeployBlessing("San Jose Norte", "housing", 75, 1000000);
    }

    function testThresholdUpdate() public {
        deployer.updateThreshold(95);
        vm.expectRevert("APR too low for auto-blessing");
        deployer.autoDeployBlessing("Mabolo", "livelihood", 90, 500000);
    }
}
