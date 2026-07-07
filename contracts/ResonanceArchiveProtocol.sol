// SPDX-License-Identifier: MIT
// Contract Name: ResonanceArchiveProtocol
// Purpose: Preserve constructive outputs and optimized habits as permanent record
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract ResonanceArchiveProtocol {
    address public chiefOperator;
    uint256 public archiveCount;

    struct Archive {
        string habit;
        string preservedOutput;
        uint256 timestamp;
    }

    Archive[] public archives;

    event ArchiveAdded(string habit, string preservedOutput, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        archiveCount = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    // Add new resonance archive entry
    function addArchive(string memory habit, string memory preservedOutput) public onlyChief {
        archives.push(Archive(habit, preservedOutput, block.timestamp));
        archiveCount++;
        emit ArchiveAdded(habit, preservedOutput, block.timestamp);
    }

    // View archive details
    function getArchive(uint256 index) public view returns (string memory, string memory, uint256) {
        require(index < archives.length, "Invalid archive index");
        Archive memory a = archives[index];
        return (a.habit, a.preservedOutput, a.timestamp);
    }
}
