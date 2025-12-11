// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// DesignRegistry: register projects with Palafox-standard design attributes
contract DesignRegistry {
    struct Project {
        uint256 id;
        string name;
        string designURI;   // architectural plans, drawings, references
        bool active;
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Project) public projects;
    address public steward;

    event ProjectRegistered(uint256 indexed id, string name);

    constructor() { steward = msg.sender; }

    function register(string calldata name, string calldata designURI) external {
        require(msg.sender == steward, "Only steward");
        projects[nextId] = Project(nextId, name, designURI, true, block.timestamp);
        emit ProjectRegistered(nextId, name);
        nextId++;
    }

    function toggle(uint256 id, bool active) external {
        require(msg.sender == steward, "Only steward");
        projects[id].active = active;
    }
}
