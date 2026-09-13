// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {NuclearEvidenceRegistry} from "./NuclearEvidenceRegistry.sol";
import {NuclearConflictRegistry} from "./NuclearConflictRegistry.sol";

contract NuclearDecisionGates {
    enum GateStatus {
        Open,
        Passed,
        Failed,
        Conditional,
        Frozen
    }

    struct Gate {
        bytes32 subject;
        uint256 requiredApprovals;
        uint256 approvals;
        GateStatus status;
        bool exists;
    }

    struct Approval {
        address reviewer;
        uint64 approvedAt;
    }

    error Unauthorized();
    error InvalidInput();
    error AlreadyExists();
    error MissingGate();
    error MissingEvidence();
    error EvidenceNotUsable();
    error AlreadyApproved();
    error GateClosed();
    error InsufficientApprovals();
    error CannotModify();
    error ConflictedReviewer();

    NuclearEvidenceRegistry public immutable evidenceRegistry;
NuclearConflictRegistry public immutable conflictRegistry;
    address public owner;

    mapping(address => bool) public reviewers;
    mapping(address => mapping(bytes32 => bool)) public reviewerConflicts;
    mapping(bytes32 => Gate) private gates;
    mapping(bytes32 => mapping(address => bool)) public hasApproved;
    mapping(bytes32 => Approval[]) private approvals;
    mapping(bytes32 => bytes32[]) private gateEvidence;

    event ReviewerUpdated(address indexed reviewer, bool authorized);
    event ReviewerConflictUpdated(
        address indexed reviewer,
        bytes32 indexed subject,
        bool conflicted
    );
    event GateCreated(
        bytes32 indexed gateId,
        bytes32 indexed subject,
        uint256 requiredApprovals
    );
    event EvidenceAttached(
        bytes32 indexed gateId,
        bytes32 indexed evidenceId
    );
    event GateApproved(
        bytes32 indexed gateId,
        address indexed reviewer,
        uint256 approvals
    );
    event GateResolved(bytes32 indexed gateId, GateStatus status);
    event GateFrozen(bytes32 indexed gateId);

    modifier onlyOwner() {
        if (msg.sender != owner) revert Unauthorized();
        _;
    }

    modifier onlyReviewer() {
        if (!reviewers[msg.sender]) revert Unauthorized();
        _;
    }

    constructor(address evidenceRegistryAddress, address conflictRegistryAddress) {
        if (evidenceRegistryAddress == address(0) || conflictRegistryAddress == address(0)) revert InvalidInput();
        owner = msg.sender;
        evidenceRegistry = NuclearEvidenceRegistry(evidenceRegistryAddress);
conflictRegistry = NuclearConflictRegistry(conflictRegistryAddress);
        reviewers[msg.sender] = true;
        emit ReviewerUpdated(msg.sender, true);
    }

    function setReviewer(address reviewer, bool authorized) external onlyOwner {
        if (reviewer == address(0)) revert InvalidInput();
        reviewers[reviewer] = authorized;
        emit ReviewerUpdated(reviewer, authorized);
    }

    function setReviewerConflict(
        address reviewer,
        bytes32 subject,
        bool conflicted
    ) external onlyOwner {
        if (reviewer == address(0) || subject == bytes32(0)) revert InvalidInput();
        reviewerConflicts[reviewer][subject] = conflicted;
        emit ReviewerConflictUpdated(reviewer, subject, conflicted);
    }

    function createGate(
        bytes32 gateId,
        bytes32 subject,
        uint256 requiredApprovals
    ) external onlyOwner {
        if (gateId == bytes32(0) || subject == bytes32(0) || requiredApprovals == 0) {
            revert InvalidInput();
        }
        if (gates[gateId].exists) revert AlreadyExists();

        gates[gateId] = Gate({
            subject: subject,
            requiredApprovals: requiredApprovals,
            approvals: 0,
            status: GateStatus.Open,
            exists: true
        });

        emit GateCreated(gateId, subject, requiredApprovals);
    }

    function attachEvidence(
        bytes32 gateId,
        bytes32 evidenceId
    ) external onlyOwner {
        Gate storage gate = gates[gateId];
        if (!gate.exists) revert MissingGate();
        if (gate.status != GateStatus.Open) revert GateClosed();
        if (!evidenceRegistry.isUsable(evidenceId)) revert EvidenceNotUsable();

        NuclearEvidenceRegistry.Evidence memory evidence =
            evidenceRegistry.getEvidence(evidenceId);

        if (evidence.subject != gate.subject) revert MissingEvidence();

        bytes32[] storage attached = gateEvidence[gateId];
        for (uint256 i; i < attached.length; ++i) {
            if (attached[i] == evidenceId) revert AlreadyExists();
        }

        attached.push(evidenceId);
        emit EvidenceAttached(gateId, evidenceId);
    }

    function approveGate(bytes32 gateId) external onlyReviewer {
        Gate storage gate = gates[gateId];
        if (!gate.exists) revert MissingGate();
        if (gate.status != GateStatus.Open) revert GateClosed();
        if (
            reviewerConflicts[msg.sender][gate.subject]
                || conflictRegistry.isConflicted(msg.sender, gate.subject)
        ) {
            revert ConflictedReviewer();
        }
        if (hasApproved[gateId][msg.sender]) revert AlreadyApproved();
        if (gateEvidence[gateId].length == 0) revert MissingEvidence();

        for (uint256 i; i < gateEvidence[gateId].length; ++i) {
            if (!evidenceRegistry.isUsable(gateEvidence[gateId][i])) {
                revert EvidenceNotUsable();
            }
        }

        hasApproved[gateId][msg.sender] = true;
        gate.approvals += 1;
        approvals[gateId].push(
            Approval({reviewer: msg.sender, approvedAt: uint64(block.timestamp)})
        );

        emit GateApproved(gateId, msg.sender, gate.approvals);

        if (gate.approvals >= gate.requiredApprovals) {
            gate.status = GateStatus.Passed;
            emit GateResolved(gateId, GateStatus.Passed);
        }
    }

    function resolveGate(
        bytes32 gateId,
        GateStatus status
    ) external onlyOwner {
        Gate storage gate = gates[gateId];
        if (!gate.exists) revert MissingGate();
        if (gate.status != GateStatus.Open) revert CannotModify();
        if (status != GateStatus.Failed && status != GateStatus.Conditional) {
            revert InvalidInput();
        }
        if (status == GateStatus.Conditional && gate.approvals < gate.requiredApprovals) {
            revert InsufficientApprovals();
        }

        gate.status = status;
        emit GateResolved(gateId, status);
    }

    function freezeGate(bytes32 gateId) external onlyOwner {
        Gate storage gate = gates[gateId];
        if (!gate.exists) revert MissingGate();
        if (gate.status == GateStatus.Frozen) revert CannotModify();

        gate.status = GateStatus.Frozen;
        emit GateFrozen(gateId);
    }

    function getGate(bytes32 gateId) external view returns (Gate memory) {
        if (!gates[gateId].exists) revert MissingGate();
        return gates[gateId];
    }

    function getGateEvidence(bytes32 gateId) external view returns (bytes32[] memory) {
        if (!gates[gateId].exists) revert MissingGate();
        return gateEvidence[gateId];
    }

    function getApprovals(bytes32 gateId) external view returns (Approval[] memory) {
        if (!gates[gateId].exists) revert MissingGate();
        return approvals[gateId];
    }

    function isPassed(bytes32 gateId) external view returns (bool) {
        return gates[gateId].status == GateStatus.Passed;
    }
}
