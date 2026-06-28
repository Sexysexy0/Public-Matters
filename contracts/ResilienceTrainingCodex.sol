// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title ResilienceTrainingCodex
/// @notice Covenant contract to safeguard communities through resilience training of students, teachers, and guards
contract ResilienceTrainingCodex {
    address public overseer;
    uint256 public trainingCount;

    struct TrainingEntry {
        uint256 id;
        string audience;
        string program;
        string location;
        uint256 timestamp;
    }

    mapping(uint256 => TrainingEntry) public trainings;

    event TrainingLogged(uint256 indexed id, string audience, string program);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logTraining(
        string calldata audience,
        string calldata program,
        string calldata location
    ) external onlyOverseer {
        trainingCount++;
        trainings[trainingCount] = TrainingEntry({
            id: trainingCount,
            audience: audience,
            program: program,
            location: location,
            timestamp: block.timestamp
        });
        emit TrainingLogged(trainingCount, audience, program);
    }

    function viewTraining(uint256 id) external view returns (TrainingEntry memory) {
        return trainings[id];
    }
}
