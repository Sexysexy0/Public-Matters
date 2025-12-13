// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// UpcycleMirror: record upcycling projects for containers
contract UpcycleMirror {
    struct Project {
        uint256 id;
        string type;      // "Housing", "Retail", "Storage"
        string location;
        string description;
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Project) public projects;
    mapping(address => bool) public stewards;

    event ProjectLogged(uint256 indexed id, string type, string location);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logProject(string calldata type, string calldata location, string calldata description) external {
        require(stewards[msg.sender], "Only steward");
        projects[nextId] = Project(nextId, type, location, description, block.timestamp);
        emit ProjectLogged(nextId, type, location);
        nextId++;
    }
}
