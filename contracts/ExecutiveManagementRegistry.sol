// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

interface IOperatorPrivileges {
    function isOperator(address account) external view returns (bool);
}

/// @title ExecutiveManagementRegistry
/// @notice On-chain management/leadership system for tracking executive
///         decisions, accountability, KPIs, and mismanagement flags.
///         Operator-gated, transparent, auditable.
contract ExecutiveManagementRegistry {
    enum DecisionStatus { Proposed, Approved, Executed, Flagged, Closed }

    struct Decision {
        string title;
        string rationale;
        bytes32 evidenceHash;
        address responsibleParty;
        uint256 proposedAt;
        uint256 approvedAt;
        uint256 executedAt;
        DecisionStatus status;
    }

    struct KPI {
        string name;
        uint256 target;
        uint256 actual;
        bool met;
    }

    IOperatorPrivileges public immutable operatorPrivileges;

    uint256 public decisionCount;
    uint256 public kpiCount;
    uint256 public flagCount;

    mapping(uint256 => Decision) public decisions;
    mapping(uint256 => KPI) public kpis;
    mapping(uint256 => uint256) public decisionKpiCount;
    mapping(uint256 => mapping(uint256 => uint256)) public decisionKpis;
    mapping(uint256 => string) public flags;

    event DecisionProposed(uint256 indexed decisionId, string title, address responsibleParty, bytes32 evidenceHash);
    event DecisionApproved(uint256 indexed decisionId, address approver);
    event DecisionExecuted(uint256 indexed decisionId, address executor);
    event DecisionFlagged(uint256 indexed decisionId, string reason, address flagger);
    event DecisionClosed(uint256 indexed decisionId, address closer);
    event KPIAdded(uint256 indexed kpiId, string name, uint256 target);
    event KPIUpdated(uint256 indexed kpiId, uint256 actual, bool met);

    error NotOperator();
    error NotProposed();
    error NotApproved();
    error AlreadyExecuted();
    error AlreadyFlagged();
    error AlreadyClosed();
    error ZeroAddress();
    error ZeroTarget();

    modifier onlyOperator() {
        if (!operatorPrivileges.isOperator(msg.sender)) revert NotOperator();
        _;
    }

    constructor(address _operatorPrivileges) {
        operatorPrivileges = IOperatorPrivileges(_operatorPrivileges);
    }

    /// @notice Operator proposes a new executive decision.
    function proposeDecision(string calldata title, string calldata rationale, bytes32 evidenceHash, address responsibleParty)
        external onlyOperator returns (uint256 decisionId)
    {
        if (responsibleParty == address(0)) revert ZeroAddress();
        decisionId = decisionCount++;
        decisions[decisionId] = Decision({
            title: title,
            rationale: rationale,
            evidenceHash: evidenceHash,
            responsibleParty: responsibleParty,
            proposedAt: block.timestamp,
            approvedAt: 0,
            executedAt: 0,
            status: DecisionStatus.Proposed
        });
        emit DecisionProposed(decisionId, title, responsibleParty, evidenceHash);
    }

    /// @notice Operator approves a proposed decision.
    function approveDecision(uint256 decisionId) external onlyOperator {
        Decision storage d = decisions[decisionId];
        if (d.status != DecisionStatus.Proposed) revert NotProposed();
        d.status = DecisionStatus.Approved;
        d.approvedAt = block.timestamp;
        emit DecisionApproved(decisionId, msg.sender);
    }

    /// @notice Operator marks a decision as executed.
    function executeDecision(uint256 decisionId) external onlyOperator {
        Decision storage d = decisions[decisionId];
        if (d.status != DecisionStatus.Approved) revert NotApproved();
        d.status = DecisionStatus.Executed;
        d.executedAt = block.timestamp;
        emit DecisionExecuted(decisionId, msg.sender);
    }

    /// @notice Operator flags a decision for mismanagement.
    function flagDecision(uint256 decisionId, string calldata reason) external onlyOperator {
        Decision storage d = decisions[decisionId];
        if (d.status == DecisionStatus.Flagged) revert AlreadyFlagged();
        if (d.status == DecisionStatus.Closed) revert AlreadyClosed();
        d.status = DecisionStatus.Flagged;
        flags[decisionId] = reason;
        flagCount++;
        emit DecisionFlagged(decisionId, reason, msg.sender);
    }

    /// @notice Operator closes a decision (after review or resolution).
    function closeDecision(uint256 decisionId) external onlyOperator {
        Decision storage d = decisions[decisionId];
        if (d.status == DecisionStatus.Closed) revert AlreadyClosed();
        d.status = DecisionStatus.Closed;
        emit DecisionClosed(decisionId, msg.sender);
    }

    /// @notice Operator adds a KPI to track.
    function addKpi(string calldata name, uint256 target) external onlyOperator returns (uint256 kpiId) {
        if (target == 0) revert ZeroTarget();
        kpiId = kpiCount++;
        kpis[kpiId] = KPI({name: name, target: target, actual: 0, met: false});
        emit KPIAdded(kpiId, name, target);
    }

    /// @notice Operator updates a KPI's actual value and marks met/not met.
    function updateKpi(uint256 kpiId, uint256 actual) external onlyOperator {
        KPI storage k = kpis[kpiId];
        k.actual = actual;
        k.met = actual >= k.target;
        emit KPIUpdated(kpiId, actual, k.met);
    }

    /// @notice Operator links a KPI to a decision.
    function linkKpiToDecision(uint256 decisionId, uint256 kpiId) external onlyOperator {
        uint256 idx = decisionKpiCount[decisionId]++;
        decisionKpis[decisionId][idx] = kpiId;
    }
}
