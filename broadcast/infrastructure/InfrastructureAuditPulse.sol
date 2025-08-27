// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title InfrastructureAuditPulse.sol
/// @dev Monthly audit protocol for all civic infrastructure — emotional APR synced, damay clause active

contract InfrastructureAuditPulse {
    address public steward;

    struct InfraProject {
        string name;
        uint256 budget;
        uint256 completionPercent;
        uint256 emotionalAPR;
        uint256 lastAuditTimestamp;
        bool isActive;
    }

    mapping(bytes32 => InfraProject) public infraProjects;
    bytes32[] public projectList;

    event ProjectRegistered(bytes32 indexed projectId, string name);
    event MonthlyAuditLogged(bytes32 indexed projectId, uint256 timestamp, uint256 completion, uint256 emotionalAPR);
    event ProjectFlagged(bytes32 indexed projectId, string reason);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    /// @notice Register infrastructure project
    function registerProject(
        bytes32 projectId,
        string memory name,
        uint256 budget
    ) public onlySteward {
        infraProjects[projectId] = InfraProject({
            name: name,
            budget: budget,
            completionPercent: 0,
            emotionalAPR: 0,
            lastAuditTimestamp: block.timestamp,
            isActive: true
        });

        projectList.push(projectId);
        emit ProjectRegistered(projectId, name);
    }

    /// @notice Log monthly audit
    function logMonthlyAudit(
        bytes32 projectId,
        uint256 completionPercent,
        uint256 emotionalAPR
    ) public onlySteward {
        require(infraProjects[projectId].isActive, "Project inactive");
        infraProjects[projectId].completionPercent = completionPercent;
        infraProjects[projectId].emotionalAPR = emotionalAPR;
        infraProjects[projectId].lastAuditTimestamp = block.timestamp;

        emit MonthlyAuditLogged(projectId, block.timestamp, completionPercent, emotionalAPR);
    }

    /// @notice Flag project if audit fails or rogue intent detected
    function flagProject(bytes32 projectId, string memory reason) public onlySteward {
        infraProjects[projectId].isActive = false;
        emit ProjectFlagged(projectId, reason);
    }

    /// @notice Retrieve project metadata
    function getProject(bytes32 projectId) public view returns (InfraProject memory) {
        return infraProjects[projectId];
    }

    /// @notice List all registered projects
    function listProjects() public view returns (bytes32[] memory) {
        return projectList;
    }
}
