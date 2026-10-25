// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract CandidateCommitmentRegistry {
    enum CommitmentKind {
        TARIFF_2018_BASELINE,
        DIESEL_50_PERCENT
    }
    enum Status {
        PROPOSED,
        COMMITTED,
        ENFORCED,
        VIOLATED
    }

    struct Commitment {
        CommitmentKind kind;
        string description;
        uint256 baselineValue; // e.g. 2018 tariff level marker, or 350 ($3.50/gal x100)
        uint256 targetValue; // e.g. 2018 tariff level, or 175 ($1.75/gal x100)
        bytes32 evidenceHash;
        uint256 proposedAt;
        uint256 deadline;
        address proposer;
        Status status;
        uint256 enforcedAt;
        uint256 violatedAt;
    }

    address public admin;
    address public federation;
    uint256 public totalCommitments;
    mapping(uint256 => Commitment) public commitments;

    event CommitmentProposed(uint256 indexed id, CommitmentKind kind, uint256 deadline);
    event CommitmentCommitted(uint256 indexed id, uint256 committedAt);
    event CommitmentEnforced(uint256 indexed id, uint256 enforcedAt);
    event CommitmentViolated(uint256 indexed id, uint256 violatedAt);

    error OnlyAdmin();
    error OnlyFederation();
    error UnknownCommitment();
    error InvalidStatus();
    error DeadlinePassed();
    error DeadlineNotPassed();
    error InvalidEvidence();

    modifier onlyAdmin() {
        if (msg.sender != admin) revert OnlyAdmin();
        _;
    }
    modifier onlyFederation() {
        if (msg.sender != federation) revert OnlyFederation();
        _;
    }

    constructor() {
        admin = msg.sender;
        federation = msg.sender;
    }

    function proposeCommitment(
        CommitmentKind kind,
        string calldata description,
        uint256 baselineValue,
        uint256 targetValue,
        bytes32 evidenceHash,
        uint256 deadline
    ) external onlyFederation returns (uint256 id) {
        if (evidenceHash == bytes32(0)) revert InvalidEvidence();
        if (deadline <= block.timestamp) revert DeadlinePassed();

        id = totalCommitments++;
        commitments[id] = Commitment({
            kind: kind,
            description: description,
            baselineValue: baselineValue,
            targetValue: targetValue,
            evidenceHash: evidenceHash,
            proposedAt: block.timestamp,
            deadline: deadline,
            proposer: msg.sender,
            status: Status.PROPOSED,
            enforcedAt: 0,
            violatedAt: 0
        });

        emit CommitmentProposed(id, kind, deadline);
    }

    function commitCommitment(uint256 id) external onlyAdmin {
        Commitment storage c = commitments[id];
        if (c.proposer == address(0)) revert UnknownCommitment();
        if (c.status != Status.PROPOSED) revert InvalidStatus();
        if (block.timestamp > c.deadline) revert DeadlinePassed();

        c.status = Status.COMMITTED;
        emit CommitmentCommitted(id, block.timestamp);
    }

    function enforceCommitment(uint256 id, bytes32 evidenceHash) external onlyAdmin {
        Commitment storage c = commitments[id];
        if (c.proposer == address(0)) revert UnknownCommitment();
        if (c.status != Status.COMMITTED) revert InvalidStatus();
        if (evidenceHash == bytes32(0)) revert InvalidEvidence();

        c.status = Status.ENFORCED;
        c.enforcedAt = block.timestamp;
        emit CommitmentEnforced(id, block.timestamp);
    }

    function markViolated(uint256 id) external {
        Commitment storage c = commitments[id];
        if (c.proposer == address(0)) revert UnknownCommitment();
        if (c.status != Status.PROPOSED && c.status != Status.COMMITTED) revert InvalidStatus();
        if (block.timestamp <= c.deadline) revert DeadlineNotPassed();

        c.status = Status.VIOLATED;
        c.violatedAt = block.timestamp;
        emit CommitmentViolated(id, block.timestamp);
    }

    function getCommitment(uint256 id) external view returns (Commitment memory) {
        if (id >= totalCommitments) revert UnknownCommitment();
        return commitments[id];
    }
}
