// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../contracts/SovereignGridProtocol.sol";

contract SovereignGridProtocolTest is Test {
    SovereignGridProtocol public grid;
    address public osg = address(this);
    address public barangay = address(0x111);
    address public consumer = address(0x222);

    function setUp() public {
        grid = new SovereignGridProtocol();
        grid.registerMicroGrid(barangay);
    }

    function testP2PEnergyTrade() public {
        // Bigyan ng pondo ang consumer
        vm.deal(consumer, 1 ether);

        // Mag-list ng sobrang kuryente ang Barangay Node (50 kWh at 0.01 ether per kWh)
        vm.prank(barangay);
        grid.listExcessEnergy(50, 0.01 ether);

        // Bibilhin ng consumer direkta sa barangay! (50 * 0.01 = 0.5 ether)
        vm.prank(consumer);
        grid.buyEnergyP2P{value: 0.5 ether}(barangay, 50);

        // Verify na naubos ang listed energy ng seller (No middleman involved!)
        (, uint256 excessKWh, ) = grid.communityGrids(barangay);
        assertEq(excessKWh, 0);
    }
}
