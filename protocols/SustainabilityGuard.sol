// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// SustainabilityGuard: record recycling and environmental measures
contract SustainabilityGuard {
    struct Measure {
        uint256 id;
        string action;     // "Recycle Steel", "Carbon Offset"
        string description;
        uint256 impact;    // estimated CO2 reduction
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Measure) public measures;
    mapping(address => bool) public stewards;

    event MeasureLogged(uint256 indexed id, string action, uint256 impact);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logMeasure(string calldata action, string calldata description, uint256 impact) external {
        require(stewards[msg.sender], "Only steward");
        measures[nextId] = Measure(nextId, action, description, impact, block.timestamp);
        emit MeasureLogged(nextId, action, impact);
        nextId++;
    }
}
