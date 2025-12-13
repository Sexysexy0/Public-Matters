// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// ProjectMirror: record factory projects using modified containers
contract ProjectMirror {
    struct Project {
        uint256 id;
        string name;
        string type;       // "Housing", "Clinic", "Retail"
        string location;
        uint256 budget;
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Project) public projects;
    mapping(address => bool) public stewards;

    event ProjectLogged(uint256 indexed id, string name, string type);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logProject(string calldata name, string calldata type, string calldata location, uint256 budget) external {
        require(stewards[msg.sender], "Only steward");
        projects[nextId] = Project(nextId, name, type, location, budget, block.timestamp);
        emit ProjectLogged(nextId, name, type);
        nextId++;
    }
}
