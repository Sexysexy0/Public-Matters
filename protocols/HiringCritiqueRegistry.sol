// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// HiringCritiqueRegistry: record critiques of corporate hiring strategies
contract HiringCritiqueRegistry {
    struct Critique {
        uint256 id;
        string user;
        string company;     // "Amazon"
        string comment;     // "Needs better hiring strategy"
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Critique) public critiques;
    mapping(address => bool) public stewards;

    event CritiqueLogged(uint256 indexed id, string user, string company, string comment);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logCritique(string calldata user, string calldata company, string calldata comment) external {
        require(stewards[msg.sender], "Only steward");
        critiques[nextId] = Critique(nextId, user, company, comment, block.timestamp);
        emit CritiqueLogged(nextId, user, company, comment);
        nextId++;
    }
}
