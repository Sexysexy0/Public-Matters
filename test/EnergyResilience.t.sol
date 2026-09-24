// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../contracts/EnergyResilience.sol";

contract EnergyResilienceTest is Test {
    EnergyResilience energy;
    address admin = address(0xABCD);
    address provider = address(0x1234);

    function setUp() public {
        vm.prank(admin);
        energy = new EnergyResilience();
    }

    function testRegisterProvider() public {
        vm.prank(admin);
        energy.registerProvider(provider);
        assertTrue(energy.renewableProviders(provider));
    }

    function testReleaseSubsidy() public {
        vm.prank(admin);
        energy.registerProvider(provider);

        vm.expectEmit(true, true, false, true);
        emit EnergyResilience.SubsidyReleased(provider, 500);

        energy.releaseSubsidy(provider, 500);
    }
}
