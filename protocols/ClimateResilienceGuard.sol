// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// ClimateResilienceGuard: record resilience features for rail lines
contract ClimateResilienceGuard {
    struct Feature {
        uint256 id;
        string line;
        string hazard;     // e.g., "Flood", "Typhoon", "Earthquake"
        string mitigation; // e.g., "Elevated viaduct", "Seismic dampers"
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Feature) public features;
    mapping(address => bool) public stewards;

    event FeatureLogged(uint256 indexed id, string line, string hazard);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logFeature(string calldata line, string calldata hazard, string calldata mitigation) external {
        require(stewards[msg.sender], "Only steward");
        features[nextId] = Feature(nextId, line, hazard, mitigation, block.timestamp);
        emit FeatureLogged(nextId, line, hazard);
        nextId++;
    }
}
