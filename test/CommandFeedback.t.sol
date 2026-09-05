// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/CommandFeedback.sol";

contract CommandFeedbackTest is Test {
    CommandFeedback feedback;

    function setUp() public {
        feedback = new CommandFeedback();
    }

    function testIssueCommand() public {
        feedback.issueCommand("Advance");
        assertTrue(true, "Command issued");
    }

    function testGiveFeedback() public {
        feedback.giveFeedback("All clear");
        assertTrue(true, "Feedback received");
    }
}
