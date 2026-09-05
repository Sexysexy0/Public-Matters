// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/HistoryLightedPath.sol";

contract HistoryLightedPathTest is Test {
    HistoryLightedPath history;

    function setUp() public {
        history = new HistoryLightedPath();
    }

    function testLogDecision() public {
        history.logDecision("Deploy governance suite");
        (address leader, string memory desc, uint256 blockNum) = history.decisions(0);
        assertEq(leader, address(this));
        assertEq(desc, "Deploy governance suite");
        assertEq(blockNum, block.number);
    }
}
