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
        vm.warp(1000);
        vm.prevrandao(bytes32(uint256(12345)));
        
        uint256 roll = jack.chaosPlay();
        assertTrue(roll >= 0 && roll < 100);
    }
}
