// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// InfiltrationMirror: record infiltration findings and consequences
contract InfiltrationMirror {
    struct Infiltration {
        uint256 id;
        string worker;
        string origin;      // "North Korea"
        string method;      // "Remote Control", "False Identity"
        string impact;      // "Corporate Risk", "National Security"
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Infiltration) public infiltrations;
    mapping(address => bool) public stewards;

    event InfiltrationLogged(uint256 indexed id, string worker, string origin, string method, string impact);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logInfiltration(string calldata worker, string calldata origin, string calldata method, string calldata impact) external {
        require(stewards[msg.sender], "Only steward");
        infiltrations[nextId] = Infiltration(nextId, worker, origin, method, impact, block.timestamp);
        emit InfiltrationLogged(nextId, worker, origin, method, impact);
        nextId++;
    }
}
