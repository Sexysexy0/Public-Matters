// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./OperatorPrivilegesV2.sol";

/**
 * @title ProjectContinuityRegistry
 * @notice On-chain registry for government/institutional projects.
 *         Tracks budget, disbursements, milestones, and cancellation attempts.
 *
 *         Directly addresses: California HSR pattern (2026-09-20),
 *         institutional discontinuity (CASE-006).
 *
 *         Purpose: prevent arbitrary cancellation of long-term projects
 *         across administration changes.
 */
contract ProjectContinuityRegistry {
    OperatorPrivilegesV2 public privileges;

    enum ProjectStatus {
        PROPOSED,
        ACTIVE,
        COMPLETED,
        STALLED,
        CANCELLATION_PENDING,
        CANCELLED
    }

    struct Project {
        uint256 id;
        bytes32 projectHash; // keccak of name + jurisdiction
        string name;
        string jurisdiction;
        uint256 totalBudget;
        uint256 totalDisbursed;
        uint256 milestonesTotal;
        uint256 milestonesCompleted;
        ProjectStatus status;
        address initiator;
        uint256 createdAt;
        uint256 lastUpdated;
        bytes32 cancellationReasonHash;
        uint256 cancellationApprovals;
    }

    struct Disbursement {
        uint256 projectId;
        uint256 amount;
        address recipient;
        bytes32 purposeHash;
        uint256 timestamp;
    }

    uint256 public projectCount;
    mapping(uint256 => Project) internal _projects;
    mapping(uint256 => Disbursement[]) internal _disbursements;
    mapping(uint256 => mapping(address => bool)) public cancellationApprovals;

    uint256 public constant CANCELLATION_THRESHOLD = 2; // 2-of-N approval
    uint256 public constant PUBLIC_NOTICE_PERIOD = 30 days;

    event ProjectRegistered(uint256 indexed id, string name, uint256 budget, address initiator);
    event DisbursementRecorded(uint256 indexed id, uint256 amount, address recipient);
    event MilestoneCompleted(uint256 indexed id, uint256 milestoneNumber, uint256 total);
    event CancellationRequested(uint256 indexed id, bytes32 reasonHash, address requester);
    event CancellationApproved(uint256 indexed id, address approver, uint256 approvals);
    event CancellationBlocked(uint256 indexed id, address blocker);
    event ProjectFinalized(uint256 indexed id, ProjectStatus finalStatus);

    modifier onlyOperator() {
        require(privileges.isOperator(msg.sender), "Not authorized operator");
        _;
    }

    modifier projectExists(uint256 projectId) {
        require(_projects[projectId].id != 0, "Project not found");
        _;
    }

    constructor(address _privileges) {
        require(_privileges != address(0), "Invalid privileges");
        privileges = OperatorPrivilegesV2(_privileges);
    }

    // ─── REGISTRATION ───

    function registerProject(
        string calldata name,
        string calldata jurisdiction,
        uint256 totalBudget,
        uint256 milestonesTotal
    ) external onlyOperator returns (uint256) {
        require(totalBudget > 0, "Budget must be > 0");
        require(milestonesTotal > 0, "Milestones must be > 0");

        projectCount++;
        uint256 id = projectCount;

        _projects[id] = Project({
            id: id,
            projectHash: keccak256(abi.encodePacked(name, jurisdiction)),
            name: name,
            jurisdiction: jurisdiction,
            totalBudget: totalBudget,
            totalDisbursed: 0,
            milestonesTotal: milestonesTotal,
            milestonesCompleted: 0,
            status: ProjectStatus.ACTIVE,
            initiator: msg.sender,
            createdAt: block.timestamp,
            lastUpdated: block.timestamp,
            cancellationReasonHash: bytes32(0),
            cancellationApprovals: 0
        });

        emit ProjectRegistered(id, name, totalBudget, msg.sender);
        return id;
    }

    // ─── DISBURSEMENTS ───

    function recordDisbursement(uint256 projectId, uint256 amount, address recipient, bytes32 purposeHash)
        external
        onlyOperator
        projectExists(projectId)
    {
        Project storage p = _projects[projectId];
        require(p.status == ProjectStatus.ACTIVE, "Project not active");
        require(p.totalDisbursed + amount <= p.totalBudget, "Exceeds budget");

        _disbursements[projectId].push(
            Disbursement({
                projectId: projectId,
                amount: amount,
                recipient: recipient,
                purposeHash: purposeHash,
                timestamp: block.timestamp
            })
        );

        p.totalDisbursed += amount;
        p.lastUpdated = block.timestamp;

        emit DisbursementRecorded(projectId, amount, recipient);
    }

    // ─── MILESTONES ───

    function completeMilestone(uint256 projectId) external onlyOperator projectExists(projectId) {
        Project storage p = _projects[projectId];
        require(p.status == ProjectStatus.ACTIVE, "Project not active");
        require(p.milestonesCompleted < p.milestonesTotal, "All milestones completed");

        p.milestonesCompleted++;
        p.lastUpdated = block.timestamp;

        emit MilestoneCompleted(projectId, p.milestonesCompleted, p.milestonesTotal);

        if (p.milestonesCompleted == p.milestonesTotal) {
            p.status = ProjectStatus.COMPLETED;
            emit ProjectFinalized(projectId, ProjectStatus.COMPLETED);
        }
    }

    // ─── CANCELLATION GUARD ───

    function requestCancellation(uint256 projectId, bytes32 reasonHash) external onlyOperator projectExists(projectId) {
        Project storage p = _projects[projectId];
        require(p.status == ProjectStatus.ACTIVE, "Project not active");
        require(reasonHash != bytes32(0), "Reason required");

        p.status = ProjectStatus.CANCELLATION_PENDING;
        p.cancellationReasonHash = reasonHash;
        p.cancellationApprovals = 1;
        p.lastUpdated = block.timestamp;

        cancellationApprovals[projectId][msg.sender] = true;

        emit CancellationRequested(projectId, reasonHash, msg.sender);
    }

    function approveCancellation(uint256 projectId) external onlyOperator projectExists(projectId) {
        Project storage p = _projects[projectId];
        require(p.status == ProjectStatus.CANCELLATION_PENDING, "No pending cancellation");
        require(!cancellationApprovals[projectId][msg.sender], "Already approved");

        cancellationApprovals[projectId][msg.sender] = true;
        p.cancellationApprovals++;
        p.lastUpdated = block.timestamp;

        emit CancellationApproved(projectId, msg.sender, p.cancellationApprovals);

        if (p.cancellationApprovals >= CANCELLATION_THRESHOLD) {
            p.status = ProjectStatus.CANCELLED;
            emit ProjectFinalized(projectId, ProjectStatus.CANCELLED);
        }
    }

    function blockCancellation(uint256 projectId) external onlyOperator projectExists(projectId) {
        Project storage p = _projects[projectId];
        require(p.status == ProjectStatus.CANCELLATION_PENDING, "No pending cancellation");

        p.status = ProjectStatus.ACTIVE;
        p.cancellationReasonHash = bytes32(0);
        p.cancellationApprovals = 0;
        p.lastUpdated = block.timestamp;

        emit CancellationBlocked(projectId, msg.sender);
    }

    function stallProject(uint256 projectId) external onlyOperator projectExists(projectId) {
        Project storage p = _projects[projectId];
        require(p.status == ProjectStatus.ACTIVE, "Not active");
        p.status = ProjectStatus.STALLED;
        p.lastUpdated = block.timestamp;
        emit ProjectFinalized(projectId, ProjectStatus.STALLED);
    }

    // ─── VIEWS ───

    function getProject(uint256 projectId) external view projectExists(projectId) returns (Project memory) {
        return _projects[projectId];
    }

    function getDisbursementCount(uint256 projectId) external view returns (uint256) {
        return _disbursements[projectId].length;
    }

    function getDisbursement(uint256 projectId, uint256 index) external view returns (Disbursement memory) {
        return _disbursements[projectId][index];
    }

    function getProjectStatus(uint256 projectId) external view returns (ProjectStatus) {
        return _projects[projectId].status;
    }

    function getBudgetUtilization(uint256 projectId) external view returns (uint256 basisPoints) {
        Project storage p = _projects[projectId];
        if (p.totalBudget == 0) return 0;
        return (p.totalDisbursed * 10000) / p.totalBudget;
    }
}
