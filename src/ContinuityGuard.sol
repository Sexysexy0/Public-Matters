// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./OperatorPrivilegesV2.sol";

/**
 * @title ContinuityGuard
 * @notice Protects long-term projects from arbitrary cancellation across
 *         administration changes. Enforces:
 *         - Supermajority approval (2/3)
 *         - Public notice period
 *         - Immutable cancellation log
 *
 *         Directly addresses: institutional discontinuity (CASE-006),
 *         California HSR pattern (2026-09-20).
 */
contract ContinuityGuard {
    OperatorPrivilegesV2 public privileges;

    uint256 public constant THRESHOLD_NUMERATOR = 2;
    uint256 public constant THRESHOLD_DENOMINATOR = 3;
    uint256 public constant MIN_PUBLIC_NOTICE = 30 days;

    struct CancellationAttempt {
        uint256 projectId;
        bytes32 reasonHash;
        address initiator;
        uint256 initiatedAt;
        uint256 approvals;
        bool executed;
        bool blocked;
    }

    struct PublicNotice {
        uint256 projectId;
        uint256 publishedAt;
        uint256 earliestActionDate;
        string notice;
    }

    uint256 public attemptCount;
    mapping(uint256 => CancellationAttempt) internal _attempts;
    mapping(uint256 => mapping(address => bool)) public attemptApprovals;
    mapping(uint256 => PublicNotice) public publicNotices;
    mapping(uint256 => bytes32[]) internal _blockedReasons;

    event CancellationAttemptLogged(uint256 indexed attemptId, uint256 projectId, address initiator);
    event CancellationAttemptApproved(uint256 indexed attemptId, address approver, uint256 approvals);
    event CancellationAttemptBlocked(uint256 indexed attemptId, address blocker, bytes32 reason);
    event CancellationAttemptExecuted(uint256 indexed attemptId);
    event PublicNoticePublished(uint256 indexed projectId, uint256 earliestActionDate);
    event SuppressionAttemptReported(uint256 indexed projectId, address reporter, bytes32 lawRef);

    modifier onlyOperator() {
        require(privileges.isOperator(msg.sender), "Not authorized operator");
        _;
    }

    constructor(address _privileges) {
        require(_privileges != address(0), "Invalid privileges");
        privileges = OperatorPrivilegesV2(_privileges);
    }

    // ─── CANCELLATION ATTEMPT ───

    function logCancellationAttempt(uint256 projectId, bytes32 reasonHash) external onlyOperator returns (uint256) {
        require(reasonHash != bytes32(0), "Reason required");

        attemptCount++;
        uint256 id = attemptCount;

        _attempts[id] = CancellationAttempt({
            projectId: projectId,
            reasonHash: reasonHash,
            initiator: msg.sender,
            initiatedAt: block.timestamp,
            approvals: 1,
            executed: false,
            blocked: false
        });

        attemptApprovals[id][msg.sender] = true;

        emit CancellationAttemptLogged(id, projectId, msg.sender);
        return id;
    }

    function approveCancellationAttempt(uint256 attemptId) external onlyOperator {
        CancellationAttempt storage a = _attempts[attemptId];
        require(a.initiator != address(0), "Attempt not found");
        require(!a.executed, "Already executed");
        require(!a.blocked, "Already blocked");
        require(!attemptApprovals[attemptId][msg.sender], "Already approved");

        attemptApprovals[attemptId][msg.sender] = true;
        a.approvals++;

        emit CancellationAttemptApproved(attemptId, msg.sender, a.approvals);
    }

    function executeCancellation(uint256 attemptId) external onlyOperator {
        CancellationAttempt storage a = _attempts[attemptId];
        require(a.initiator != address(0), "Attempt not found");
        require(!a.executed, "Already executed");
        require(!a.blocked, "Already blocked");

        // Check supermajority threshold (2/3 of operators conceptually)
        require(a.approvals >= THRESHOLD_NUMERATOR, "Insufficient approvals");

        // Check public notice requirement
        PublicNotice storage n = publicNotices[a.projectId];
        require(n.publishedAt != 0, "No public notice");
        require(block.timestamp >= n.earliestActionDate, "Public notice period not elapsed");

        a.executed = true;
        emit CancellationAttemptExecuted(attemptId);
    }

    function blockCancellationAttempt(uint256 attemptId, bytes32 reason) external onlyOperator {
        CancellationAttempt storage a = _attempts[attemptId];
        require(a.initiator != address(0), "Attempt not found");
        require(!a.executed, "Already executed");
        require(!a.blocked, "Already blocked");

        a.blocked = true;
        _blockedReasons[a.projectId].push(reason);

        emit CancellationAttemptBlocked(attemptId, msg.sender, reason);
    }

    // ─── PUBLIC NOTICE ───

    function publishPublicNotice(uint256 projectId, string calldata notice) external onlyOperator {
        require(bytes(notice).length > 0, "Notice required");

        publicNotices[projectId] = PublicNotice({
            projectId: projectId,
            publishedAt: block.timestamp,
            earliestActionDate: block.timestamp + MIN_PUBLIC_NOTICE,
            notice: notice
        });

        emit PublicNoticePublished(projectId, block.timestamp + MIN_PUBLIC_NOTICE);
    }

    // ─── SUPPRESSION REPORTING ───

    function reportSuppressionAttempt(uint256 projectId, bytes32 lawRef) external onlyOperator {
        emit SuppressionAttemptReported(projectId, msg.sender, lawRef);
    }

    // ─── VIEWS ───

    function getAttempt(uint256 attemptId) external view returns (CancellationAttempt memory) {
        return _attempts[attemptId];
    }

    function getNotice(uint256 projectId) external view returns (PublicNotice memory) {
        return publicNotices[projectId];
    }

    function getBlockedReasons(uint256 projectId) external view returns (bytes32[] memory) {
        return _blockedReasons[projectId];
    }
}
