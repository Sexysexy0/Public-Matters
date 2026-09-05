// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../contracts/EventBoard.sol";

contract EventBoardTest is Test {
    EventBoard board;

    function setUp() public {
        board = new EventBoard();
    }

    function testPostEvent() public {
        board.postEvent("Update", "Patch 1.0 released");
        (string memory title, string memory desc,) = board.getEvent(0);
        assertEq(title, "Update");
        assertEq(desc, "Patch 1.0 released");
    }

    function testUpdateEvent() public {
        board.postEvent("Notice", "Server maintenance");
        board.updateEvent(0, "Notice", "Server maintenance extended");
        (, string memory desc,) = board.getEvent(0);
        assertEq(desc, "Server maintenance extended");
    }
}
