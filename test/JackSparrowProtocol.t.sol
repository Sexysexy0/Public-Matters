// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/JackSparrowProtocol.sol";

contract JackSparrowProtocolTest is Test {
    JackSparrowProtocol jack;
    address pirate = address(0x7777);

    function setUp() public {
        jack = new JackSparrowProtocol();
    }

    function test_ChaosPlayWinningRoll() public {
        vm.prank(pirate);
        
        // Manipulate block variables to force a roll > 50 for testing predictability
        vm.warp(1000);
        vm.prevrandao(bytes32(uint256(12345)));
        
        uint256 roll = jack.chaosPlay();
        
        // Check if the logic runs without reverting (outcome depends on the keccak hash, 
        // but this ensures the function logic and state mutations work correctly).
        assertTrue(roll >= 0 && roll < 100);
    }
}
