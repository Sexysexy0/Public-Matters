// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// HighwayLedger: record checkpoints on national highways
contract HighwayLedger {
    struct HighwayCheckpoint {
        uint256 id;
        string highway;
        string location;
        bool active;
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => HighwayCheckpoint) public checkpoints;
    mapping(address => bool) public stewards;

    event HighwayCheckpointLogged(uint256 indexed id, string highway, string location);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logCheckpoint(string calldata highway, string calldata location, bool active) external {
        require(stewards[msg.sender], "Only steward");
        checkpoints[nextId] = HighwayCheckpoint(nextId, highway, location, active, block.timestamp);
        emit HighwayCheckpointLogged(nextId, highway, location);
        nextId++;
    }
}
