// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Creator Chain
/// @notice Hierarchical registry of creators; encodes ranks and authority across projects
contract CreatorChain {
    address public guardian;
    uint256 public creatorCount;
    uint256 public projectCount;

    enum Rank {
        Creator,
        SeniorCreator,
        LeadCreator,
        VisionHolder
    }

    struct Creator {
        uint256 id;
        address account;
        Rank rank;
        string specialty;
        bool active;
    }

    struct Project {
        uint256 id;
        string name;
        address visionHolder;
        uint256[] creatorIds;
        bool active;
    }

    mapping(uint256 => Creator) public creators;
    mapping(address => uint256) public creatorByAddress;
    mapping(uint256 => Project) public projects;

    event GuardianChanged(address indexed oldGuardian, address indexed newGuardian);
    event CreatorAdded(uint256 indexed id, address account, Rank rank, string specialty);
    event CreatorRankChanged(uint256 indexed id, Rank oldRank, Rank newRank);
    event ProjectCreated(uint256 indexed id, string name, address visionHolder);
    event ProjectCreatorLinked(uint256 indexed projectId, uint256 indexed creatorId);

    constructor() {
        guardian = msg.sender;
        creatorCount = 0;
        projectCount = 0;
    }

    modifier onlyGuardian() {
        require(msg.sender == guardian, "Not authorized");
        _;
    }

    function changeGuardian(address newGuardian) external onlyGuardian {
        require(newGuardian != address(0), "Invalid guardian");
        emit GuardianChanged(guardian, newGuardian);
        guardian = newGuardian;
    }

    function addCreator(
        address account,
        Rank rank,
        string calldata specialty
    ) external onlyGuardian {
        require(account != address(0), "Invalid account");
        require(creatorByAddress[account] == 0, "Creator already exists");

        creatorCount++;
        creators[creatorCount] = Creator(creatorCount, account, rank, specialty, true);
        creatorByAddress[account] = creatorCount;

        emit CreatorAdded(creatorCount, account, rank, specialty);
    }

    function changeCreatorRank(
        uint256 creatorId,
        Rank newRank
    ) external onlyGuardian {
        Creator storage c = creators[creatorId];
        require(c.active, "Creator not active");

        Rank oldRank = c.rank;
        c.rank = newRank;

        emit CreatorRankChanged(creatorId, oldRank, newRank);
    }

    function createProject(
        string calldata name,
        address visionHolder
    ) external onlyGuardian {
        require(bytes(name).length > 0, "Name required");
        uint256 vhId = creatorByAddress[visionHolder];
        require(vhId != 0, "Vision holder must be a registered creator");
        require(creators[vhId].rank == Rank.VisionHolder, "Vision holder must have VisionHolder rank");

        projectCount++;
        Project storage p = projects[projectCount];
        p.id = projectCount;
        p.name = name;
        p.visionHolder = visionHolder;
        p.active = true;

        emit ProjectCreated(projectCount, name, visionHolder);
    }

    function linkCreatorToProject(
        uint256 projectId,
        uint256 creatorId
    ) external onlyGuardian {
        Project storage p = projects[projectId];
        require(p.active, "Project not active");

        Creator storage c = creators[creatorId];
        require(c.active, "Creator not active");

        p.creatorIds.push(creatorId);
        emit ProjectCreatorLinked(projectId, creatorId);
    }

    function viewCreator(uint256 id) external view returns (Creator memory) {
        return creators[id];
    }

    function viewProject(uint256 id) external view returns (Project memory) {
        return projects[id];
    }

    function getProjectCreators(uint256 projectId) external view returns (uint256[] memory) {
        return projects[projectId].creatorIds;
    }
}
