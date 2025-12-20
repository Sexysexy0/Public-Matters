// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// RemoteControlRegistry: record remote control anomalies
contract RemoteControlRegistry {
    struct RemoteEvent {
        uint256 id;
        string worker;
        string anomaly;     // "Keystroke Lag", "Unusual IP"
        string status;      // "Detected", "Investigated"
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => RemoteEvent) public events;
    mapping(address => bool) public stewards;

    event RemoteEventLogged(uint256 indexed id, string worker, string anomaly, string status);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logRemoteEvent(string calldata worker, string calldata anomaly, string calldata status) external {
        require(stewards[msg.sender], "Only steward");
        events[nextId] = RemoteEvent(nextId, worker, anomaly, status, block.timestamp);
        emit RemoteEventLogged(nextId, worker, anomaly, status);
        nextId++;
    }
}
