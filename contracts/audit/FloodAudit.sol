// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract FloodAudit {
    struct Project {
        string location;
        string projectName;
        uint256 budgetAllocated;
        uint256 budgetUsed;
        bool damayClauseActive;
        bool verified;
    }

    Project[] public projects;
    address public steward;

    event ProjectLogged(string location, string projectName, uint256 budgetAllocated);
    event DamayClauseActivated(string location, string projectName);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized scrollcaster");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function logProject(
        string memory _location,
        string memory _projectName,
        uint256 _budgetAllocated
    ) external onlySteward {
        projects.push(Project(_location, _projectName, _budgetAllocated, 0, false, false));
        emit ProjectLogged(_location, _projectName, _budgetAllocated);
    }

    function activateDamayClause(uint256 _id) external onlySteward {
        require(_id < projects.length, "Invalid project ID");
        projects[_id].damayClauseActive = true;
        emit DamayClauseActivated(projects[_id].location, projects[_id].projectName);
    }

    function verifyProject(uint256 _id, uint256 _budgetUsed) external onlySteward {
        require(_id < projects.length, "Invalid project ID");
        projects[_id].budgetUsed = _budgetUsed;
        projects[_id].verified = true;
    }

    function getProject(uint256 _id) external view returns (Project memory) {
        return projects[_id];
    }

    function getProjectCount() external view returns (uint256) {
        return projects.length;
    }
}
