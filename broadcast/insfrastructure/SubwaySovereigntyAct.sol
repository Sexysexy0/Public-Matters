// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title SubwaySovereigntyAct.sol
/// @dev Infrastructure integrity protocol — blocks corrupt oversight, enforces emotional APR, and damay clause

contract SubwaySovereigntyAct {
    address public steward;

    struct Project {
        string name;
        uint256 budget;
        uint256 commuterCapacity;
        string[] stationTags;
        uint256 emotionalAPR;
        bool isApproved;
    }

    mapping(bytes32 => Project) public subwayProjects;
    mapping(address => bool) public disqualifiedOfficials;
    bytes32[] public projectList;

    event ProjectRegistered(bytes32 indexed projectId, string name);
    event OfficialDisqualified(address indexed official, string reason);
    event ProjectApproved(bytes32 indexed projectId, string reason);
    event ProjectBlocked(bytes32 indexed projectId, string reason);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    /// @notice Register a subway project with full civic metadata
    function registerProject(
        bytes32 projectId,
        string memory name,
        uint256 budget,
        uint256 commuterCapacity,
        string[] memory stationTags,
        uint256 emotionalAPR
    ) public onlySteward {
        subwayProjects[projectId] = Project({
            name: name,
            budget: budget,
            commuterCapacity: commuterCapacity,
            stationTags: stationTags,
            emotionalAPR: emotionalAPR,
            isApproved: false
        });

        projectList.push(projectId);
        emit ProjectRegistered(projectId, name);
    }

    /// @notice Disqualify officials with unresolved corruption or rogue oversight
    function disqualifyOfficial(address official, string memory reason) public onlySteward {
        disqualifiedOfficials[official] = true;
        emit OfficialDisqualified(official, reason);
    }

    /// @notice Approve project if emotional APR is high and no rogue oversight detected
    function approveProject(bytes32 projectId) public onlySteward {
        require(subwayProjects[projectId].emotionalAPR >= 850, "Emotional APR too low");
        subwayProjects[projectId].isApproved = true;
        emit ProjectApproved(projectId, "Project passed emotional APR and damay clause");
    }

    /// @notice Block project if rogue oversight or commuter betrayal detected
    function blockProject(bytes32 projectId, string memory reason) public onlySteward {
        subwayProjects[projectId].isApproved = false;
        emit ProjectBlocked(projectId, reason);
    }

    /// @notice Retrieve project metadata
    function getProject(bytes32 projectId) public view returns (Project memory) {
        return subwayProjects[projectId];
    }

    /// @notice List all registered subway projects
    function listProjects() public view returns (bytes32[] memory) {
        return projectList;
    }
}
