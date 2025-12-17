// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// StyleMirror: record vocal style changes
contract StyleMirror {
    struct Style {
        uint256 id;
        string delivery;    // "Calm", "Energetic", "Narrative"
        string status;      // "Old", "New"
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Style) public styles;
    mapping(address => bool) public stewards;

    event StyleLogged(uint256 indexed id, string delivery, string status);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logStyle(string calldata delivery, string calldata status) external {
        require(stewards[msg.sender], "Only steward");
        styles[nextId] = Style(nextId, delivery, status, block.timestamp);
        emit StyleLogged(nextId, delivery, status);
        nextId++;
    }
}
