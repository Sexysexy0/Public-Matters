// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title ClassroomResilienceLedger
/// @notice Covenant contract to monitor classroom construction targets and resilience
contract ClassroomResilienceLedger {
    address public overseer;
    uint256 public classroomCount;

    struct ClassroomEntry {
        uint256 id;
        uint256 target;
        uint256 completed;
        string location;
        uint256 timestamp;
    }

    mapping(uint256 => ClassroomEntry) public classrooms;

    event ClassroomLogged(uint256 indexed id, uint256 target, uint256 completed);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logClassroom(
        uint256 target,
        uint256 completed,
        string calldata location
    ) external onlyOverseer {
        classroomCount++;
        classrooms[classroomCount] = ClassroomEntry({
            id: classroomCount,
            target: target,
            completed: completed,
            location: location,
            timestamp: block.timestamp
        });
        emit ClassroomLogged(classroomCount, target, completed);
    }

    function viewClassroom(uint256 id) external view returns (ClassroomEntry memory) {
        return classrooms[id];
    }
}
