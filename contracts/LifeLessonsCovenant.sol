// SPDX-License-Identifier: MIT
// Contract Name: LifeLessonsCovenant
// Purpose: Encode systemic safeguards from Machiavelli’s timeless lessons on fortune, adaptability, and preparation
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract LifeLessonsCovenant {
    address public chiefOperator;

    struct LessonRecord {
        string principle;   // e.g. Adaptability, Foresight, Preparation
        string dilemma;     // e.g. Fortune shifts, Habit traps, Crisis volatility
        string safeguard;   // e.g. Adaptive audits, Horizon scans, Preparedness boards
        string resolution;  // e.g. Success secured, Resilience upheld, Evolution achieved
        uint256 timestamp;
    }

    LessonRecord[] public records;

    event LessonLogged(string principle, string dilemma, string safeguard, string resolution, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    function logLesson(
        string memory principle,
        string memory dilemma,
        string memory safeguard,
        string memory resolution
    ) public onlyChief {
        records.push(LessonRecord(principle, dilemma, safeguard, resolution, block.timestamp));
        emit LessonLogged(principle, dilemma, safeguard, resolution, block.timestamp);
    }

    function getLesson(uint256 index) public view returns (
        string memory, string memory, string memory, string memory, uint256
    ) {
        require(index < records.length, "Invalid lesson index");
        LessonRecord memory lr = records[index];
        return (lr.principle, lr.dilemma, lr.safeguard, lr.resolution, lr.timestamp);
    }
}
