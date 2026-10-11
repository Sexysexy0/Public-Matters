// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./OperatorPrivileges.sol";

/**
 * @title BudgetDeliberationRegistry
 * @notice On-chain transparency registry for budget proposals that go
 *         through legislative deliberation. Every citizen can query:
 *           - What was proposed (title, amount, category)
 *           - Who proposed it
 *           - How it was deliberated (votes, arguments hash)
 *           - Whether it was approved or rejected
 *           - How much has been disbursed
 *           - What audit has been done
 *
 * Answers the citizen demand: "Nasaan ang pera? Bakit ganito ang budget?"
 *
 * Maps to:
 *   - Manifesto: Transparency, Inclusive Governance, Measured Impact
 *   - Public Matters: budget accountability from deliberation to disbursement
 */
contract BudgetDeliberationRegistry {

    OperatorPrivileges public privileges;

    enum Stage {
        PROPOSED,
        DELIBERATING,
        APPROVED,
        REJECTED,
        DISBURSING,
        COMPLETED,
        AUDITED
    }

    struct Proposal {
        bytes32 id;
        string title;
        string category;         // "health", "infra", "education", etc.
        uint256 amount;          // in wei (or smallest unit)
        address proposer;
        uint256 createdAt;
        Stage stage;
        uint256 votesFor;
        uint256 votesAgainst;
        bytes32 deliberationHash; // hash of full deliberation record
        uint256 approvedAt;
        uint256 disbursedAmount;
        bytes32 auditHash;
        string auditVerdict;
    }

    struct Disbursement {
        bytes32 proposalId;
        uint256 amount;
        uint256 timestamp;
        address releasedBy;
        string purpose;
        bytes32 evidenceHash;
    }

    mapping(bytes32 => Proposal) public proposals;
    mapping(bytes32 => Disbursement[]) public disbursements;
    bytes32[] public proposalIds;

    // Track per-category totals for aggregate queries
    mapping(string => uint256) public totalProposedByCategory;
    mapping(string => uint256) public totalApprovedByCategory;
    mapping(string => uint256) public totalDisbursedByCategory;

    uint256 public totalProposals;
    uint256 public totalDisbursed;

    event ProposalCreated(
        bytes32 indexed id,
        string title,
        string category,
        uint256 amount,
        address indexed proposer
    );

    event DeliberationStarted(bytes32 indexed id);
    event VoteCast(bytes32 indexed id, address indexed voter, bool inFavor);
    event DeliberationSealed(bytes32 indexed id, bytes32 deliberationHash);
    event ProposalApproved(bytes32 indexed id, uint256 finalAmount);
    event ProposalRejected(bytes32 indexed id, string reason);
    event DisbursementReleased(
        bytes32 indexed id,
        uint256 amount,
        address indexed releasedBy,
        bytes32 evidenceHash
    );
    event AuditRecorded(bytes32 indexed id, bytes32 auditHash, string verdict);

    modifier onlyOperator() {
        require(privileges.isOperator(msg.sender), "Not authorized operator");
        _;
    }

    modifier proposalExists(bytes32 id) {
        require(proposals[id].createdAt != 0, "Proposal not found");
        _;
    }

    constructor(address _privileges) {
        privileges = OperatorPrivileges(_privileges);
    }

    // ─────────────────────────────────────────────────────────────
    // 1. PROPOSAL — dito nagsisimula ang lahat
    // ─────────────────────────────────────────────────────────────

    function createProposal(
        string calldata title,
        string calldata category,
        uint256 amount,
        address proposer
    ) external onlyOperator returns (bytes32) {
        bytes32 id = keccak256(
            abi.encode(title, category, amount, proposer, block.timestamp, totalProposals)
        );
        require(proposals[id].createdAt == 0, "Proposal already exists");

        Proposal storage p = proposals[id];
        p.id = id;
        p.title = title;
        p.category = category;
        p.amount = amount;
        p.proposer = proposer;
        p.createdAt = block.timestamp;
        p.stage = Stage.PROPOSED;

        proposalIds.push(id);
        totalProposals++;
        totalProposedByCategory[category] += amount;

        emit ProposalCreated(id, title, category, amount, proposer);
        return id;
    }

    // ─────────────────────────────────────────────────────────────
    // 2. DELIBERATION — ang bawat boto ay naka-record
    // ─────────────────────────────────────────────────────────────

    function startDeliberation(bytes32 id)
        external
        onlyOperator
        proposalExists(id)
    {
        require(proposals[id].stage == Stage.PROPOSED, "Not in PROPOSED stage");
        proposals[id].stage = Stage.DELIBERATING;
        emit DeliberationStarted(id);
    }

    function castVote(bytes32 id, bool inFavor)
        external
        onlyOperator
        proposalExists(id)
    {
        Proposal storage p = proposals[id];
        require(p.stage == Stage.DELIBERATING, "Not in DELIBERATING stage");

        if (inFavor) {
            p.votesFor++;
        } else {
            p.votesAgainst++;
        }
        emit VoteCast(id, msg.sender, inFavor);
    }

    function sealDeliberation(bytes32 id, bytes32 deliberationHash)
        external
        onlyOperator
        proposalExists(id)
    {
        Proposal storage p = proposals[id];
        require(p.stage == Stage.DELIBERATING, "Not in DELIBERATING stage");
        p.deliberationHash = deliberationHash;
        emit DeliberationSealed(id, deliberationHash);
    }

    // ─────────────────────────────────────────────────────────────
    // 3. APPROVAL / REJECTION — final decision
    // ─────────────────────────────────────────────────────────────

    function approveProposal(bytes32 id, uint256 finalAmount)
        external
        onlyOperator
        proposalExists(id)
    {
        Proposal storage p = proposals[id];
        require(p.stage == Stage.DELIBERATING, "Not in DELIBERATING stage");
        require(p.votesFor > p.votesAgainst, "Majority did not approve");

        p.stage = Stage.APPROVED;
        p.amount = finalAmount;
        p.approvedAt = block.timestamp;

        totalApprovedByCategory[p.category] += finalAmount;

        emit ProposalApproved(id, finalAmount);
    }

    function rejectProposal(bytes32 id, string calldata reason)
        external
        onlyOperator
        proposalExists(id)
    {
        Proposal storage p = proposals[id];
        require(
            p.stage == Stage.DELIBERATING || p.stage == Stage.PROPOSED,
            "Cannot reject at this stage"
        );
        p.stage = Stage.REJECTED;
        emit ProposalRejected(id, reason);
    }

    // ─────────────────────────────────────────────────────────────
    // 4. DISBURSEMENT — kada piso na lumalabas, naka-track
    // ─────────────────────────────────────────────────────────────

    function releaseDisbursement(
        bytes32 id,
        uint256 amount,
        string calldata purpose,
        bytes32 evidenceHash
    ) external onlyOperator proposalExists(id) {
        Proposal storage p = proposals[id];
        require(
            p.stage == Stage.APPROVED || p.stage == Stage.DISBURSING,
            "Proposal not approved"
        );
        require(
            p.disbursedAmount + amount <= p.amount,
            "Disbursement exceeds approved amount"
        );

        p.disbursedAmount += amount;
        p.stage = Stage.DISBURSING;
        if (p.disbursedAmount == p.amount) {
            p.stage = Stage.COMPLETED;
        }

        disbursements[id].push(Disbursement({
            proposalId: id,
            amount: amount,
            timestamp: block.timestamp,
            releasedBy: msg.sender,
            purpose: purpose,
            evidenceHash: evidenceHash
        }));

        totalDisbursed += amount;
        totalDisbursedByCategory[p.category] += amount;

        emit DisbursementReleased(id, amount, msg.sender, evidenceHash);
    }

    // ─────────────────────────────────────────────────────────────
    // 5. AUDIT — independent verification
    // ─────────────────────────────────────────────────────────────

    function recordAudit(
        bytes32 id,
        bytes32 auditHash,
        string calldata verdict
    ) external onlyOperator proposalExists(id) {
        Proposal storage p = proposals[id];
        p.auditHash = auditHash;
        p.auditVerdict = verdict;
        p.stage = Stage.AUDITED;
        emit AuditRecorded(id, auditHash, verdict);
    }

    // ─────────────────────────────────────────────────────────────
    // 6. PUBLIC QUERIES — para sa kahit sinong mamamayan
    // ─────────────────────────────────────────────────────────────

    function getProposal(bytes32 id)
        external
        view
        proposalExists(id)
        returns (Proposal memory)
    {
        return proposals[id];
    }

    function getDisbursements(bytes32 id)
        external
        view
        returns (Disbursement[] memory)
    {
        return disbursements[id];
    }

    function getAllProposalIds() external view returns (bytes32[] memory) {
        return proposalIds;
    }

    function getCategorySummary(string calldata category)
        external
        view
        returns (
            uint256 proposed,
            uint256 approved,
            uint256 disbursed
        )
    {
        return (
            totalProposedByCategory[category],
            totalApprovedByCategory[category],
            totalDisbursedByCategory[category]
        );
    }

    function getProposalCount() external view returns (uint256) {
        return proposalIds.length;
    }

    function getDisbursementCount(bytes32 id) external view returns (uint256) {
        return disbursements[id].length;
    }
}
