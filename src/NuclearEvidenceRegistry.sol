// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract NuclearEvidenceRegistry {
    enum Status {
        Draft,
        Submitted,
        UnderReview,
        Accepted,
        AcceptedWithConditions,
        Rejected,
        CorrectionRequested,
        Superseded,
        Frozen
    }

    struct Evidence {
        bytes32 subject;
        bytes32 sourceHash;
        address submittedBy;
        address reviewedBy;
        Status status;
        bytes32 supersedes;
        uint64 createdAt;
        uint64 reviewedAt;
    }

    error Unauthorized();
    error AlreadyExists();
    error MissingEvidence();
    error InvalidTransition();
    error FrozenRecord();
    error InvalidReviewer();

    mapping(bytes32 => Evidence) private evidence;
    mapping(address => bool) public reviewers;
    address public owner;

    event ReviewerUpdated(address indexed reviewer, bool authorized);
    event EvidenceRegistered(
        bytes32 indexed evidenceId,
        bytes32 indexed subject,
        bytes32 sourceHash,
        address indexed submitter
    );
    event EvidenceReviewed(
        bytes32 indexed evidenceId,
        address indexed reviewer,
        Status status
    );
    event EvidenceCorrected(
        bytes32 indexed originalId,
        bytes32 indexed correctionId
    );
    event EvidenceSuperseded(
        bytes32 indexed originalId,
        bytes32 indexed replacementId
    );
    event EvidenceFrozen(bytes32 indexed evidenceId);

    modifier onlyOwner() {
        if (msg.sender != owner) revert Unauthorized();
        _;
    }

    modifier onlyReviewer() {
        if (!reviewers[msg.sender]) revert InvalidReviewer();
        _;
    }

    constructor() {
        owner = msg.sender;
        reviewers[msg.sender] = true;
        emit ReviewerUpdated(msg.sender, true);
    }

    function setReviewer(address reviewer, bool authorized) external onlyOwner {
        if (reviewer == address(0)) revert InvalidReviewer();
        reviewers[reviewer] = authorized;
        emit ReviewerUpdated(reviewer, authorized);
    }

    function registerEvidence(
        bytes32 evidenceId,
        bytes32 subject,
        bytes32 sourceHash
    ) external {
        if (evidenceId == bytes32(0) || subject == bytes32(0) || sourceHash == bytes32(0)) {
            revert MissingEvidence();
        }
        if (evidence[evidenceId].createdAt != 0) revert AlreadyExists();

        evidence[evidenceId] = Evidence({
            subject: subject,
            sourceHash: sourceHash,
            submittedBy: msg.sender,
            reviewedBy: address(0),
            status: Status.Submitted,
            supersedes: bytes32(0),
            createdAt: uint64(block.timestamp),
            reviewedAt: 0
        });

        emit EvidenceRegistered(evidenceId, subject, sourceHash, msg.sender);
    }

    function submitCorrection(
        bytes32 correctionId,
        bytes32 originalId,
        bytes32 sourceHash
    ) external {
        Evidence storage original = evidence[originalId];
        if (original.createdAt == 0) revert MissingEvidence();
        if (original.status == Status.Frozen) revert FrozenRecord();
        if (correctionId == bytes32(0) || sourceHash == bytes32(0)) revert MissingEvidence();
        if (evidence[correctionId].createdAt != 0) revert AlreadyExists();

        evidence[correctionId] = Evidence({
            subject: original.subject,
            sourceHash: sourceHash,
            submittedBy: msg.sender,
            reviewedBy: address(0),
            status: Status.Submitted,
            supersedes: originalId,
            createdAt: uint64(block.timestamp),
            reviewedAt: 0
        });

        emit EvidenceCorrected(originalId, correctionId);
    }

    function reviewEvidence(
        bytes32 evidenceId,
        Status newStatus
    ) external onlyReviewer {
        Evidence storage record = evidence[evidenceId];
        if (record.createdAt == 0) revert MissingEvidence();
        if (record.status == Status.Frozen || record.status == Status.Superseded) {
            revert FrozenRecord();
        }
        if (
            newStatus != Status.Accepted &&
            newStatus != Status.AcceptedWithConditions &&
            newStatus != Status.Rejected &&
            newStatus != Status.CorrectionRequested
        ) {
            revert InvalidTransition();
        }

        record.reviewedBy = msg.sender;
        record.reviewedAt = uint64(block.timestamp);
        record.status = newStatus;

        emit EvidenceReviewed(evidenceId, msg.sender, newStatus);
    }

    function supersedeEvidence(
        bytes32 originalId,
        bytes32 replacementId
    ) external onlyReviewer {
        Evidence storage original = evidence[originalId];
        Evidence storage replacement = evidence[replacementId];

        if (original.createdAt == 0 || replacement.createdAt == 0) {
            revert MissingEvidence();
        }
        if (original.status == Status.Frozen || original.status == Status.Superseded) {
            revert FrozenRecord();
        }
        if (replacement.status != Status.Accepted && replacement.status != Status.AcceptedWithConditions) {
            revert InvalidTransition();
        }

        original.status = Status.Superseded;
        emit EvidenceSuperseded(originalId, replacementId);
    }

    function freezeEvidence(bytes32 evidenceId) external onlyOwner {
        Evidence storage record = evidence[evidenceId];
        if (record.createdAt == 0) revert MissingEvidence();
        record.status = Status.Frozen;
        emit EvidenceFrozen(evidenceId);
    }

    function getEvidence(bytes32 evidenceId) external view returns (Evidence memory) {
        if (evidence[evidenceId].createdAt == 0) revert MissingEvidence();
        return evidence[evidenceId];
    }

    function isUsable(bytes32 evidenceId) external view returns (bool) {
        Status status = evidence[evidenceId].status;
        return status == Status.Accepted || status == Status.AcceptedWithConditions;
    }
}
