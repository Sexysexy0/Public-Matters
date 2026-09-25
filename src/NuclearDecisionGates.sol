// SPDX-License-Identifier: MIT
pragma solidity 0.8.35;

interface INuclearConflictRegistry {
    function isConflicted(address reviewer, bytes32 subjectId) external view returns (bool);
}

interface INuclearEvidenceRegistry {
    function isUsable(bytes32 evidenceId) external view returns (bool);
}

contract NuclearDecisionGates {
    address public gatekeeper;
    address public owner;
    address public evidenceRegistry;
    address public conflictRegistry;

    error MissingEvidence();
    error AlreadyExists();
    error UnauthorizedReviewer();
    error ReviewerConflicted();
    error AlreadyApproved();
    error GateUnauthorized();
    error ConflictedReviewer();
    error EvidenceNotUsable();
    error InvalidGate();
    error InvalidThreshold();

    enum GateStatus {
        Open,
        Closed,
        Approved
    }

    struct Gate {
        bytes32 subject;
        bool exists;
        bool active;
        uint256 approvalThreshold;
        bool approved;
        GateStatus status;
        uint256 approvals;
    }

    mapping(bytes32 => Gate) public gates;
    mapping(bytes32 => bytes32[]) public evidenceRegistryStorage;
    mapping(address => bool) public isReviewer;
    mapping(address => mapping(bytes32 => bool)) public reviewerConflicts;
    mapping(bytes32 => mapping(address => bool)) public hasApproved;

    event ReviewerStatusUpdated(address indexed reviewer, bool indexed status);
    event ReviewerConflictUpdated(address indexed reviewer, bytes32 indexed subject, bool indexed status);
    event GateCreated(bytes32 indexed gateId, bytes32 indexed subject, uint256 approvalThreshold);
    event EvidenceVerified(bytes32 indexed gateId, bytes32 indexed evidenceId);
    event GateApproved(bytes32 indexed gateId);

    modifier onlyGatekeeper() {
        if (msg.sender != gatekeeper) revert GateUnauthorized();
        _;
    }

    modifier onlyAuthorizedReviewer() {
        if (!isReviewer[msg.sender]) revert UnauthorizedReviewer();
        _;
    }

    constructor(address _evidence, address _conflicts) {
        require(_evidence != address(0), "Evidence core tracker zero address check failed");
        require(_conflicts != address(0), "Conflict core tracker zero address check failed");

        gatekeeper = msg.sender;
        owner = msg.sender;
        evidenceRegistry = _evidence;
        conflictRegistry = _conflicts;
    }

    function setReviewer(address reviewer, bool authorized) external onlyGatekeeper {
        require(reviewer != address(0), "Zero address configuration guard");

        isReviewer[reviewer] = authorized;
        emit ReviewerStatusUpdated(reviewer, authorized);
    }

    function setReviewerConflict(address reviewer, bytes32 subject, bool conflicted) external onlyGatekeeper {
        require(reviewer != address(0), "Zero address configuration guard");

        reviewerConflicts[reviewer][subject] = conflicted;
        emit ReviewerConflictUpdated(reviewer, subject, conflicted);
    }

    function createGate(bytes32 gateId, bytes32 subjectId, uint256 approvalThreshold) external onlyGatekeeper {
        if (gateId == bytes32(0) || subjectId == bytes32(0)) {
            revert InvalidGate();
        }
        if (approvalThreshold == 0) {
            revert InvalidThreshold();
        }
        if (gates[gateId].exists) {
            revert AlreadyExists();
        }

        gates[gateId] = Gate({
            subject: subjectId,
            exists: true,
            active: true,
            approvalThreshold: approvalThreshold,
            approved: false,
            status: GateStatus.Open,
            approvals: 0
        });

        emit GateCreated(gateId, subjectId, approvalThreshold);
    }

    function attachEvidence(bytes32 gateId, bytes32 evidenceId) public onlyAuthorizedReviewer {
        Gate storage gate = gates[gateId];

        if (!gate.exists || !gate.active) {
            revert InvalidGate();
        }
        if (evidenceId == bytes32(0)) {
            revert MissingEvidence();
        }
        if (!INuclearEvidenceRegistry(evidenceRegistry).isUsable(evidenceId)) {
            revert EvidenceNotUsable();
        }

        bytes32[] storage attached = evidenceRegistryStorage[gateId];

        for (uint256 i = 0; i < attached.length; i++) {
            if (attached[i] == evidenceId) {
                revert AlreadyExists();
            }
        }

        attached.push(evidenceId);
        emit EvidenceVerified(gateId, evidenceId);
    }

    function verifyEvidenceIntegrity(bytes32 gateId, bytes32 evidenceId) external onlyAuthorizedReviewer {
        attachEvidence(gateId, evidenceId);
    }

    function approveGate(bytes32 gateId) external onlyAuthorizedReviewer {
        Gate storage gate = gates[gateId];

        if (!gate.exists || !gate.active) {
            revert InvalidGate();
        }
        if (hasApproved[gateId][msg.sender]) {
            revert AlreadyApproved();
        }

        if (
            reviewerConflicts[msg.sender][gate.subject]
                || INuclearConflictRegistry(conflictRegistry).isConflicted(msg.sender, gate.subject)
        ) {
            revert ConflictedReviewer();
        }

        hasApproved[gateId][msg.sender] = true;
        gate.approvals++;

        if (gate.approvals >= gate.approvalThreshold) {
            gate.approved = true;
            gate.active = false;
            gate.status = GateStatus.Approved;
            emit GateApproved(gateId);
        }
    }

    function isPassed(bytes32 gateId) external view returns (bool) {
        return gates[gateId].approved;
    }

    function getGate(bytes32 gateId) external view returns (Gate memory) {
        return gates[gateId];
    }

    function getGateEvidence(bytes32 gateId) external view returns (bytes32[] memory) {
        return evidenceRegistryStorage[gateId];
    }
}
