// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// PublicPerceptionMirror: capture signal of public reception (likes, views, sentiment)
contract PublicPerceptionMirror {
    struct Signal {
        uint256 id;
        string contentURI;
        uint256 views;
        uint256 likes;
        int256 sentiment;   // -100 to +100
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Signal) public signals;
    mapping(address => bool) public stewards;

    event SignalLogged(uint256 indexed id, string contentURI, int256 sentiment);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logSignal(string calldata contentURI, uint256 views, uint256 likes, int256 sentiment) external {
        require(stewards[msg.sender], "Only steward");
        signals[nextId] = Signal(nextId, contentURI, views, likes, sentiment, block.timestamp);
        emit SignalLogged(nextId, contentURI, sentiment);
        nextId++;
    }
}
