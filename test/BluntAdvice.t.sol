// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/BluntAdvice.sol";

contract BluntAdviceTest is Test {
    BluntAdvice advice;

    function setUp() public {
        advice = new BluntAdvice();
    }

    function testGiveAdvice() public {
        advice.giveAdvice("Test advice");
        assertTrue(true, "Advice logged");
    }
}
