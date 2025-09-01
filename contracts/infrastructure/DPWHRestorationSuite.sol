// SPDX-License-Identifier: Mythic
pragma solidity ^0.8.19;

contract DPWHRestorationSuite {
    address public steward;

    struct Project {
        string name;
        string location;
        uint256 budget;
        bool revived;
        bool ghostFlagged;
        bool sanctumRestored;
        bool permitVerified;
    }

    mapping(uint => Project) public projects;
    uint public projectCount;

    event ProjectRevived(string name, string location, uint256 budget);
    event GhostFlagged(string name, string location);
    event SanctumRestored(string name, string location);
    event PermitVerified(string barangay);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    function addProject(
        string memory name,
        string memory location,
        uint256 budget
    ) public onlySteward {
        projects[projectCount++] = Project(name, location, budget, false, false, false, false);
    }

    function reviveProject(uint id) public onlySteward {
        projects[id].revived = true;
        emit ProjectRevived(projects[id].name, projects[id].location, projects[id].budget);
    }

    function flagGhost(uint id) public onlySteward {
        projects[id].ghostFlagged = true;
        emit GhostFlagged(projects[id].name, projects[id].location);
    }

    function restoreSanctum(uint id) public onlySteward {
        projects[id].sanctumRestored = true;
        emit SanctumRestored(projects[id].name, projects[id].location);
    }

    function verifyPermit(uint id, string memory barangay) public onlySteward {
        projects[id].permitVerified = true;
        emit PermitVerified(barangay);
    }

    function getProject(uint id) public view returns (Project memory) {
        return projects[id];
    }
}
