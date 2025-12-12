// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// OpsReadiness: record training, maintenance, and mission availability
contract OpsReadiness {
    struct Readiness {
        uint256 id;
        uint256 platformId;
        uint256 trainedPilots;    // count
        uint256 missionCapableRate; // 0–100
        uint256 flightHourCost;   // USD per hour
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Readiness) public readiness;
    mapping(address => bool) public stewards;

    event ReadinessLogged(uint256 indexed id, uint256 platformId, uint256 missionCapableRate);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logReadiness(
        uint256 platformId,
        uint256 trainedPilots,
        uint256 missionCapableRate,
        uint256 flightHourCost
    ) external {
        require(stewards[msg.sender], "Only steward");
        readiness[nextId] = Readiness(nextId, platformId, trainedPilots, missionCapableRate, flightHourCost, block.timestamp);
        emit ReadinessLogged(nextId, platformId, missionCapableRate);
        nextId++;
    }
}
