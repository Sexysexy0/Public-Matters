// SPDX-License-Identifier: MIT
// Contract Name: FeedbackLoopCovenant
// Purpose: Optimize internal habits and hobbies into constructive governance
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract FeedbackLoopCovenant {
    address public chiefOperator;
    uint256 public loopCount;

    struct Loop {
        string habit;
        string optimization;
        uint256 timestamp;
    }

    Loop[] public loops;

    event LoopAdded(string habit, string optimization, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        loopCount = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    // Add new feedback loop optimization
    function addLoop(string memory habit, string memory optimization) public onlyChief {
        loops.push(Loop(habit, optimization, block.timestamp));
        loopCount++;
        emit LoopAdded(habit, optimization, block.timestamp);
    }

    // View loop details
    function getLoop(uint256 index) public view returns (string memory, string memory, uint256) {
        require(index < loops.length, "Invalid loop index");
        Loop memory l = loops[index];
        return (l.habit, l.optimization, l.timestamp);
    }
}
