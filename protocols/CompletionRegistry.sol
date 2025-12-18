// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// CompletionRegistry: record declared completions of projects
contract CompletionRegistry {
    struct Completion {
        uint256 id;
        string project;
        string declaration; // "100% Completed"
        uint256 date;
        string authority;   // "DPWH Portal"
    }

    uint256 public nextId;
    mapping(uint256 => Completion) public completions;
    mapping(address => bool) public stewards;

    event CompletionLogged(uint256 indexed id, string project, string declaration, string authority);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logCompletion(string calldata project, string calldata declaration, uint256 date, string calldata authority) external {
        require(stewards[msg.sender], "Only steward");
        completions[nextId] = Completion(nextId, project, declaration, date, authority);
        emit CompletionLogged(nextId, project, declaration, authority);
        nextId++;
    }
}
