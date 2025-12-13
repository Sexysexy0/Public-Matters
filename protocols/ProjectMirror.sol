// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// ProjectMirror: record actual redevelopment projects
contract ProjectMirror {
    struct Project {
        uint256 id;
        string name;
        string zone;
        string type;       // "Market", "Housing", "Park"
        uint256 cost;
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Project) public projects;
    mapping(address => bool) public stewards;

    event ProjectLogged(uint256 indexed id, string name, string zone);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logProject(string calldata name, string calldata zone, string calldata type, uint256 cost) external {
        require(stewards[msg.sender], "Only steward");
        projects[nextId] = Project(nextId, name, zone, type, cost, block.timestamp);
        emit ProjectLogged(nextId, name, zone);
        nextId++;
    }
}
