// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// ResilienceGuard: record climate resilience features of relocation sites
contract ResilienceGuard {
    struct Feature {
        uint256 id;
        string site;
        string hazard;     // "Flood", "Typhoon", "Earthquake"
        string mitigation; // "Elevated housing", "Storm drains"
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Feature) public features;
    mapping(address => bool) public stewards;

    event FeatureLogged(uint256 indexed id, string site, string hazard);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logFeature(string calldata site, string calldata hazard, string calldata mitigation) external {
        require(stewards[msg.sender], "Only steward");
        features[nextId] = Feature(nextId, site, hazard, mitigation, block.timestamp);
        emit FeatureLogged(nextId, site, hazard);
        nextId++;
    }
}
