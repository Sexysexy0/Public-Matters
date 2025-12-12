// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// ValuesMirror: record social values and religious tolerance indicators
contract ValuesMirror {
    struct ValueProfile {
        uint256 id;
        string country;
        string indicator;   // e.g., "Christian population", "Social conservatism"
        string detail;
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => ValueProfile) public values;
    mapping(address => bool) public stewards;

    event ValueLogged(uint256 indexed id, string country, string indicator);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logValue(string calldata country, string calldata indicator, string calldata detail) external {
        require(stewards[msg.sender], "Only steward");
        values[nextId] = ValueProfile(nextId, country, indicator, detail, block.timestamp);
        emit ValueLogged(nextId, country, indicator);
        nextId++;
    }
}
