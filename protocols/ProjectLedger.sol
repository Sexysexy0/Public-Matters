// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// ProjectLedger: record infrastructure projects and contracts
contract ProjectLedger {
    struct Project {
        uint256 id;
        string name;        // "School Building"
        uint256 budget;     // e.g. 8500000
        string status;      // "Ongoing", "Declared Completed"
        uint256 startDate;
        uint256 declaredCompletionDate;
    }

    uint256 public nextId;
    mapping(uint256 => Project) public projects;
    mapping(address => bool) public stewards;

    event ProjectLogged(uint256 indexed id, string name, uint256 budget, string status);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logProject(
        string calldata name,
        uint256 budget,
        string calldata status,
        uint256 startDate,
        uint256 declaredCompletionDate
    ) external {
        require(stewards[msg.sender], "Only steward");
        projects[nextId] = Project(nextId, name, budget, status, startDate, declaredCompletionDate);
        emit ProjectLogged(nextId, name, budget, status);
        nextId++;
    }
}
