// SPDX-License-Identifier: MIT
pragma solidity 0.8.35;

interface ITrustIntegrator {
    function logPositiveAction(address entity, uint256 actionType) external;
    function logSetback(address entity, uint256 setbackType) external;
}

/**
 * @title InfrastructureProofRegistry
 * @notice Prevents ghost projects and license renting via milestone verification and TrustIndex integration.
 */
contract InfrastructureProofRegistry {
    address public immutable owner;
    ITrustIntegrator public immutable trustIntegrator;

    enum ProjectStatus {
        Proposed,
        Active,
        Completed,
        Audited,
        Failed
    }

    struct Project {
        string name;
        address contractor;
        uint256 budget;
        uint256 disbursed;
        uint256 completedMilestones;
        uint256 totalMilestones;
        ProjectStatus status;
    }

    mapping(uint256 => Project) public projects;
    mapping(address => uint256) public contractorLicenseBitmap;
    uint256 public projectCount;

    event ProjectRegistered(uint256 indexed projectId, string name, address indexed contractor, uint256 budget);
    event MilestoneApproved(uint256 indexed projectId, uint256 milestoneIndex, uint256 payout);
    event ProjectStatusUpdated(uint256 indexed projectId, ProjectStatus status);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner permitted");
        _;
    }

    constructor(address _trustIntegrator) {
        require(_trustIntegrator != address(0), "Invalid integrator address");
        owner = msg.sender;
        trustIntegrator = ITrustIntegrator(_trustIntegrator);
    }

    function registerContractorLicense(address contractor, uint256 licenseCategoryBitmap) external onlyOwner {
        contractorLicenseBitmap[contractor] = licenseCategoryBitmap;
    }

    function registerProject(
        string calldata name,
        address contractor,
        uint256 totalMilestones,
        uint256 requiredLicenseCategory
    ) external payable onlyOwner returns (uint256 projectId) {
        require(msg.value > 0, "Budget must be greater than zero");
        require(totalMilestones > 0, "Milestones must be greater than zero");
        require(
            (contractorLicenseBitmap[contractor] & requiredLicenseCategory) == requiredLicenseCategory,
            "Contractor lacks required license bitmap"
        );

        projectId = ++projectCount;
        projects[projectId] = Project({
            name: name,
            contractor: contractor,
            budget: msg.value,
            disbursed: 0,
            completedMilestones: 0,
            totalMilestones: totalMilestones,
            status: ProjectStatus.Active
        });

        emit ProjectRegistered(projectId, name, contractor, msg.value);
    }

    function approveMilestone(uint256 projectId) external onlyOwner {
        Project storage proj = projects[projectId];
        require(proj.status == ProjectStatus.Active, "Project not active");
        require(proj.completedMilestones < proj.totalMilestones, "All milestones already completed");

        proj.completedMilestones++;
        uint256 payout = proj.budget / proj.totalMilestones;
        proj.disbursed += payout;

        if (proj.completedMilestones == proj.totalMilestones) {
            proj.status = ProjectStatus.Completed;
            trustIntegrator.logPositiveAction(proj.contractor, 1);
        }

        (bool success,) = payable(proj.contractor).call{value: payout}("");
        require(success, "Payout transfer failed");

        emit MilestoneApproved(projectId, proj.completedMilestones, payout);
    }

    function reportAuditFailure(uint256 projectId) external onlyOwner {
        Project storage proj = projects[projectId];
        require(proj.status == ProjectStatus.Active, "Project not active");

        proj.status = ProjectStatus.Failed;
        trustIntegrator.logSetback(proj.contractor, 1);

        emit ProjectStatusUpdated(projectId, ProjectStatus.Failed);
    }
}
