// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// EnforcementMirror: record law enforcement actions
contract EnforcementMirror {
    struct Action {
        uint256 id;
        string agency;      // "PNP", "NBI"
        string operation;   // "Rescue", "Arrest"
        string outcome;     // "Successful", "Ongoing"
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Action) public actions;
    mapping(address => bool) public stewards;

    event ActionLogged(uint256 indexed id, string agency, string operation, string outcome);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logAction(string calldata agency, string calldata operation, string calldata outcome) external {
        require(stewards[msg.sender], "Only steward");
        actions[nextId] = Action(nextId, agency, operation, outcome, block.timestamp);
        emit ActionLogged(nextId, agency, operation, outcome);
        nextId++;
    }
}
