// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// HemisphereLedger: record doctrine arcs in Western Hemisphere
contract HemisphereLedger {
    struct Doctrine {
        uint256 id;
        string name;        // "Trump Doctrine", "Monroe Doctrine"
        string scope;       // "Western Hemisphere", "Latin America"
        bool active;
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Doctrine) public doctrines;
    mapping(address => bool) public stewards;

    event DoctrineLogged(uint256 indexed id, string name, string scope);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logDoctrine(string calldata name, string calldata scope, bool active) external {
        require(stewards[msg.sender], "Only steward");
        doctrines[nextId] = Doctrine(nextId, name, scope, active, block.timestamp);
        emit DoctrineLogged(nextId, name, scope);
        nextId++;
    }
}
