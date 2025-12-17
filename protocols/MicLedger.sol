// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// MicLedger: record microphone and hardware setups
contract MicLedger {
    struct Mic {
        uint256 id;
        string model;       // "Blue Yeti", "Shure SM7B"
        string setup;       // "USB", "XLR + Interface"
        string status;      // "Active", "Changed"
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Mic) public mics;
    mapping(address => bool) public stewards;

    event MicLogged(uint256 indexed id, string model, string setup, string status);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logMic(string calldata model, string calldata setup, string calldata status) external {
        require(stewards[msg.sender], "Only steward");
        mics[nextId] = Mic(nextId, model, setup, status, block.timestamp);
        emit MicLogged(nextId, model, setup, status);
        nextId++;
    }
}
