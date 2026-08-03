// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title InfrastructureIntegrityLedger
 * @dev On-Chain BIM Metadata Verification, Structural Audit Attestations & Milestone Escrow
 */
contract InfrastructureIntegrityLedger {
    address public rootAdmin;

    struct Project {
        string projectName;
        bytes32 bimModelHash;        // Hash of official BIM/CAD blueprints
        uint256 totalBudget;
        uint256 releasedBudget;
        uint256 completedMilestones;
        bool isCompleted;
    }

    struct Milestone {
        string description;
        uint256 payoutAmount;
        bool isAudited;
        bool isApproved;
    }

    mapping(uint256 => Project) public projects;
    mapping(uint256 => Milestone[]) public projectMilestones;
    mapping(uint256 => mapping(uint256 => mapping(address => bool))) public auditorSignatures;

    uint256 public projectCount;

    event ProjectRegistered(uint256 indexed projectId, string projectName, bytes32 bimModelHash);
    event MilestoneAudited(uint256 indexed projectId, uint256 indexed milestoneIndex, address indexed auditor);
    event MilestoneApproved(uint256 indexed projectId, uint256 indexed milestoneIndex, uint256 amountReleased);

    modifier onlyAdmin() {
        require(msg.sender == rootAdmin, "IIL: Only Root Admin authorized");
        _;
    }

    constructor() {
        rootAdmin = msg.sender;
    }

    function registerProject(
        string memory _projectName,
        bytes32 _bimModelHash,
        string[] memory _milestoneDescriptions,
        uint256[] memory _payoutAmounts
    ) external onlyAdmin returns (uint256) {
        require(_milestoneDescriptions.length == _payoutAmounts.length, "IIL: Mismatched milestone data");

        uint256 total = 0;
        for (uint256 i = 0; i < _payoutAmounts.length; i++) {
            total += _payoutAmounts[i];
        }

        projectCount++;
        projects[projectCount] = Project({
            projectName: _projectName,
            bimModelHash: _bimModelHash,
            totalBudget: total,
            releasedBudget: 0,
            completedMilestones: 0,
            isCompleted: false
        });

        for (uint256 i = 0; i < _milestoneDescriptions.length; i++) {
            projectMilestones[projectCount].push(Milestone({
                description: _milestoneDescriptions[i],
                payoutAmount: _payoutAmounts[i],
                isAudited: false,
                isApproved: false
            }));
        }

        emit ProjectRegistered(projectCount, _projectName, _bimModelHash);
        return projectCount;
    }

    function submitAuditSignature(uint256 _projectId, uint256 _milestoneIndex) external {
        require(_projectId <= projectCount && _projectId > 0, "IIL: Invalid project");
        require(_milestoneIndex < projectMilestones[_projectId].length, "IIL: Invalid milestone");

        auditorSignatures[_projectId][_milestoneIndex][msg.sender] = true;
        projectMilestones[_projectId][_milestoneIndex].isAudited = true;

        emit MilestoneAudited(_projectId, _milestoneIndex, msg.sender);
    }

    function approveMilestoneRelease(uint256 _projectId, uint256 _milestoneIndex) external onlyAdmin {
        Milestone storage milestone = projectMilestones[_projectId][_milestoneIndex];
        require(milestone.isAudited, "IIL: Milestone must be audited first");
        require(!milestone.isApproved, "IIL: Milestone already approved");

        milestone.isApproved = true;
        projects[_projectId].releasedBudget += milestone.payoutAmount;
        projects[_projectId].completedMilestones++;

        if (projects[_projectId].completedMilestones == projectMilestones[_projectId].length) {
            projects[_projectId].isCompleted = true;
        }

        emit MilestoneApproved(_projectId, _milestoneIndex, milestone.payoutAmount);
    }
}
