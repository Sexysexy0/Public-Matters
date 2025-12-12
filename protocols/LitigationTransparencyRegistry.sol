// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// LitigationTransparencyRegistry: record demand letters, responses, and litigation status
contract LitigationTransparencyRegistry {
    struct Case {
        uint256 id;
        string parties;     // e.g., "Ryan vs Crenshaw"
        string demandURI;   // demand letter
        string responseURI; // lawyer response
        bool active;
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Case) public cases;
    mapping(address => bool) public stewards;

    event CaseLogged(uint256 indexed id, string parties);
    event CaseUpdated(uint256 indexed id, bool active);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logCase(string calldata parties, string calldata demandURI, string calldata responseURI, bool active) external {
        require(stewards[msg.sender], "Only steward");
        cases[nextId] = Case(nextId, parties, demandURI, responseURI, active, block.timestamp);
        emit CaseLogged(nextId, parties);
        nextId++;
    }

    function updateStatus(uint256 id, bool active) external {
        require(stewards[msg.sender], "Only steward");
        cases[id].active = active;
        emit CaseUpdated(id, active);
    }
}
