// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// ResonanceBoard: capture communal sentiment + oversight on prompt injection
contract ResonanceBoard {
    struct Signal {
        uint256 id;
        string community;   // "Users", "Researchers", "Agencies"
        string sentiment;   // "Concern", "Warning", "Mitigation"
        string description;
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Signal) public signals;
    mapping(address => bool) public stewards;

    event SignalLogged(uint256 indexed id, string community, string sentiment);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logSignal(string calldata community, string calldata sentiment, string calldata description) external {
        require(stewards[msg.sender], "Only steward");
        signals[nextId] = Signal(nextId, community, sentiment, description, block.timestamp);
        emit SignalLogged(nextId, community, sentiment);
        nextId++;
    }
}
