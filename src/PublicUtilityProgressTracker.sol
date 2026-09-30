// SPDX-License-Identifier: MIT
pragma solidity ^0.8.35;

/**
 * @title PublicUtilityProgressTracker
 * @notice Sinusubaybayan ang mga pampublikong imprastraktura at milestone achievements
 *         para sa transparency ng mga apektadong mamamayan (e.g., waterlines, flood control).
 */
contract PublicUtilityProgressTracker {
    struct Milestone {
        string description;
        bool completed;
        uint256 timestamp;
        string proofHash; // IPFS hash o cryptographic verification proof
    }

    struct Project {
        uint256 projectId;
        string name; // e.g., "McArthur Highway Main Pipeline Reconstruction"
        string location; // e.g., "Malolos, Bulacan"
        uint256 totalMilestones;
        uint256 completedMilestones;
        bool active;
    }

    address public operator;
    uint256 public projectCount;

    mapping(uint256 => Project) public projects;
    mapping(uint256 => mapping(uint256 => Milestone)) public projectMilestones;

    event ProjectRegistered(uint256 indexed projectId, string name, string location);
    event MilestoneAdded(uint256 indexed projectId, uint256 indexed milestoneIndex, string description);
    event MilestoneCompleted(uint256 indexed projectId, uint256 indexed milestoneIndex, string proofHash);

    modifier onlyOperator() {
        require(msg.sender == operator, "Unauthorized: Only operator");
        _;
    }

    constructor() {
        operator = msg.sender;
    }

    function registerProject(string memory name, string memory location) external onlyOperator returns (uint256) {
        projectCount++;
        projects[projectCount] = Project({
            projectId: projectCount,
            name: name,
            location: location,
            totalMilestones: 0,
            completedMilestones: 0,
            active: true
        });

        emit ProjectRegistered(projectCount, name, location);
        return projectCount;
    }

    function addMilestone(uint256 projectId, string memory description) external onlyOperator {
        require(projects[projectId].active, "Project inactive or not found");
        uint256 mIndex = projects[projectId].totalMilestones;

        projectMilestones[projectId][mIndex] =
            Milestone({description: description, completed: false, timestamp: 0, proofHash: ""});

        projects[projectId].totalMilestones++;
        emit MilestoneAdded(projectId, mIndex, description);
    }

    function completeMilestone(uint256 projectId, uint256 milestoneIndex, string memory proofHash)
        external
        onlyOperator
    {
        require(projects[projectId].active, "Project inactive");
        require(milestoneIndex < projects[projectId].totalMilestones, "Invalid milestone index");

        Milestone storage m = projectMilestones[projectId][milestoneIndex];
        require(!m.completed, "Already completed");

        m.completed = true;
        m.timestamp = block.timestamp;
        m.proofHash = proofHash;

        projects[projectId].completedMilestones++;

        emit MilestoneCompleted(projectId, milestoneIndex, proofHash);
    }

    function getProjectProgress(uint256 projectId)
        external
        view
        returns (string memory name, uint256 total, uint256 completed)
    {
        Project memory p = projects[projectId];
        return (p.name, p.totalMilestones, p.completedMilestones);
    }
}
