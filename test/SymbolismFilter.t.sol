// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/SymbolismFilter.sol";

contract SymbolismFilterTest is Test {
    SymbolismFilter filter;

    function setUp() public {
        filter = new SymbolismFilter();
    }

    function testFlagSymbol() public {
        filter.flagSymbol(1, "17");
        string memory symbol = filter.getSymbol(1);
        assertEq(symbol, "17");
    }
}
