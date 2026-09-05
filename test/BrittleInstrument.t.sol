// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/BrittleInstrument.sol";

contract BrittleInstrumentTest is Test {
    BrittleInstrument instrument;

    function setUp() public {
        instrument = new BrittleInstrument();
    }

    function testStartOperationAndExpiry() public {
        instrument.startOperation("Temporary fallback", 5);
        assertTrue(instrument.isActive(0));
    }
}
