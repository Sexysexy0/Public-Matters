// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../contracts/SovereignHarvestProtocol.sol";

contract SovereignHarvestProtocolTest is Test {
    SovereignHarvestProtocol public harvest;
    address public farmer = address(0x101); // Magsasaka mula Bulacan
    address public consumer = address(0x202); // Mamimili mula Metro Manila

    function setUp() public {
        harvest = new SovereignHarvestProtocol();
    }

    function testDirectPurchaseNoMiddleman() public {
        // Bigyan ng pondo ang consumer
        vm.deal(consumer, 10 ether);

        // Step 1: Magsasaka lists 1000 kg of Rice (Palay) at 0.001 ether per kg
        vm.prank(farmer);
        harvest.listCrop("Palay/Rice", 1000, 0.001 ether);

        // Step 2: Consumer buys directly! (1000 kg * 0.001 = 1 ether)
        vm.prank(consumer);
        harvest.buyCropDirect{value: 1 ether}(0);

        // Step 3: Verify the farmer received the EXACT funds (Walang kaltas ang middleman!)
        assertEq(farmer.balance, 1 ether);
        
        // Verify listing is correctly marked as sold
        (,,,, bool isSold) = harvest.cropListings(0);
        assertTrue(isSold);
    }
}
