// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * Public Infrastructure Transparency Covenant
 * Purpose: Require DPWH to submit updated project inventory
 * Effect: Track project status, trigger alerts for delays
 * Safeguard: Governance body final approval
 */

contract InfrastructureTransparency {
    address public governanceBody;

    enum Status { Ongoing, Pending, Delayed, Abandoned }

    struct Project {
        string name;
        string location;
        Status status;
        uint256 lastUpdate;
    }

    mapping(uint256 => Project) public projects;
    uint256 public projectCount;

    event ProjectSubmitted(uint256 indexed id, string name, string location);
    event ProjectUpdated(uint256 indexed id, Status status);
    event UrgentActionRequired(uint256 indexed id, string name, Status status);

    modifier onlyGovernance() {
        require(msg.sender == governanceBody, "Not authorized");
        _;
    }

    constructor() {
        governanceBody = msg.sender;
    }

    // Submit new project
    function submitProject(string calldata name, string calldata location) external onlyGovernance {
        projectCount++;
        projects[projectCount] = Project(name, location, Status.Pending, block.timestamp);
        emit ProjectSubmitted(projectCount, name, location);
    }

    // Update project status
    function updateStatus(uint256 id, Status status) external onlyGovernance {
        require(id <= projectCount, "Invalid project ID");
        projects[id].status = status;
        projects[id].lastUpdate = block.timestamp;
        emit ProjectUpdated(id, status);

        if (status == Status.Delayed || status == Status.Abandoned) {
            emit UrgentActionRequired(id, projects[id].name, status);
        }
    }

    // Check if project needs urgent action
    function needsUrgentAction(uint256 id) external view returns (bool) {
        require(id <= projectCount, "Invalid project ID");
        Project memory p = projects[id];
        return (p.status == Status.Delayed || p.status == Status.Abandoned);
    }

    // Transfer governance authority
    function transferGovernance(address newGov) external onlyGovernance {
        require(newGov != address(0), "Invalid address");
        governanceBody = newGov;
    }
}
