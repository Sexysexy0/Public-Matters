// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./OperatorPrivileges.sol";
import "./TieredApproval.sol";

/**
 * @title BudgetDeliberationRegistry
 * @notice On-chain transparency registry for budget proposals.
 *
 * Tier model: every proposal declares its required authority tier at
 * creation. Approval requires BOTH:
 *   - Legacy majority:  votesFor > votesAgainst
 *   - Tier threshold:   board >= requiredBoard(tier) AND
 *                       stockholders >= requiredStockholder(tier)
 *
 * The tier is recorded on the proposal and flows through to
 * AIDecisionAudit via BudgetAuditIntegrator. A citizen can query
 * `getProposal(id).requiredTier` to see what authority a budget
 * decision required, and `getAction(id)` to see whether a single
 * actor alone carried that threshold.
 */
contract BudgetDeliberationRegistry is TieredApproval {

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
        string category;
        uint256 amount;
        address proposer;
        uint256 createdAt;
        Stage stage;
        Tier requiredTier;
        // Combined tally (informational; both vote classes contribute)
        uint256 votesFor;
        uint256 votesAgainst;
        // Board tally (counts, one vote per operator call)
        uint256 boardVotesFor;
        uint256 boardVotesAgainst;
        // Stockholder tally (basis points)
        uint256 stockholderForBps;
        uint256 stockholderAgainstBps;
        bytes32 deliberationHash;
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

    // Per-proposal, per-voter weights, used for sole-actor detection
    mapping(bytes32 => mapping(address => uint256)) public boardVoteWeight;
    mapping(bytes32 => mapping(address => uint256)) public stockholderVoteWeight;

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
        address indexed proposer,
        Tier requiredTier
    );
    event DeliberationStarted(bytes32 indexed id);
    event VoteCast(bytes32 indexed id, address indexed voter, bool inFavor);
    event BoardVoteCast(bytes32 indexed id, address indexed voter, bool inFavor);
    event StockholderVoteCast(bytes32 indexed id, address indexed voter, uint256 weightBps, bool inFavor);
    event DeliberationSealed(bytes32 indexed id, bytes32 deliberationHash);
    event ProposalApproved(bytes32 indexed id, uint256 finalAmount, Tier tier);
    event ProposalRejected(bytes32 indexed id, string reason);
    event DisbursementReleased(bytes32 indexed id, uint256 amount, address indexed releasedBy, bytes32 evidenceHash);
    event AuditRecorded(bytes32 indexed id, bytes32 auditHash, string verdict);
    event CompositionSet(uint256 boardTotal, uint256 stockholderTotal);

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
    // 0. COMPOSITION — totals for tier thresholds
    // ─────────────────────────────────────────────────────────────

    function setComposition(uint256 _boardTotal, uint256 _stockholderTotal) external onlyOperator {
        _setComposition(_boardTotal, _stockholderTotal);
        emit CompositionSet(_boardTotal, _stockholderTotal);
    }

    // ─────────────────────────────────────────────────────────────
    // 1. PROPOSAL
    // ─────────────────────────────────────────────────────────────

    function createProposal(
        string calldata title,
        string calldata category,
        uint256 amount,
        address proposer,
        Tier requiredTier
    ) external onlyOperator returns (bytes32) {
        require(requiredTier != Tier.NONE, "requiredTier=NONE");

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
        p.requiredTier = requiredTier;

        proposalIds.push(id);
        totalProposals++;
        totalProposedByCategory[category] += amount;

        emit ProposalCreated(id, title, category, amount, proposer, requiredTier);
        return id;
    }

    // ─────────────────────────────────────────────────────────────
    // 2. DELIBERATION
    // ─────────────────────────────────────────────────────────────

    function startDeliberation(bytes32 id) external onlyOperator proposalExists(id) {
        require(proposals[id].stage == Stage.PROPOSED, "Not in PROPOSED stage");
        proposals[id].stage = Stage.DELIBERATING;
        emit DeliberationStarted(id);
    }

    /// @notice Legacy general vote. Contributes to combined tally only.
    ///         Does NOT satisfy tier thresholds; use castBoardVote /
    ///         castStockholderVote for tier-bearing votes.
    function castVote(bytes32 id, bool inFavor) external onlyOperator proposalExists(id) {
        Proposal storage p = proposals[id];
        require(p.stage == Stage.DELIBERATING, "Not in DELIBERATING stage");
        if (inFavor) {
            p.votesFor++;
        } else {
            p.votesAgainst++;
        }
        emit VoteCast(id, msg.sender, inFavor);
    }

    /// @notice Board vote. One call = one board vote. Also increments the
    ///         combined tally. Operators are trusted to vote their true
    ///         seat count; abuse is handled by OperatorPrivileges removal.
    function castBoardVote(bytes32 id, bool inFavor) external onlyOperator proposalExists(id) {
        Proposal storage p = proposals[id];
        require(p.stage == Stage.DELIBERATING, "Not in DELIBERATING stage");
        if (inFavor) {
            p.boardVotesFor++;
            p.votesFor++;
            boardVoteWeight[id][msg.sender] += 1;
        } else {
            p.boardVotesAgainst++;
            p.votesAgainst++;
        }
        emit BoardVoteCast(id, msg.sender, inFavor);
    }

    /// @notice Stockholder vote with declared weight in basis points
    ///         (10000 = 100%). Contributes to combined tally AND to the
    ///         stockholder tier tally. Operators are trusted to declare
    ///         their true weight; a lying operator is visible on-chain
    ///         and removable via OperatorPrivileges.
    function castStockholderVote(bytes32 id, uint256 weightBps, bool inFavor)
        external
        onlyOperator
        proposalExists(id)
    {
        Proposal storage p = proposals[id];
        require(p.stage == Stage.DELIBERATING, "Not in DELIBERATING stage");
        require(weightBps <= 10000, "weightBps > 10000");

        if (inFavor) {
            p.stockholderForBps += weightBps;
            p.votesFor++;
            stockholderVoteWeight[id][msg.sender] += weightBps;
        } else {
            p.stockholderAgainstBps += weightBps;
            p.votesAgainst++;
        }
        emit StockholderVoteCast(id, msg.sender, weightBps, inFavor);
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
    // 3. APPROVAL / REJECTION
    // ─────────────────────────────────────────────────────────────

    function approveProposal(bytes32 id, uint256 finalAmount)
        external
        onlyOperator
        proposalExists(id)
    {
        Proposal storage p = proposals[id];
        require(p.stage == Stage.DELIBERATING, "Not in DELIBERATING stage");
        require(p.votesFor > p.votesAgainst, "Majority did not approve");
        require(
            meetsThreshold(p.requiredTier, p.boardVotesFor, p.stockholderForBps),
            "Tier not achieved"
        );

        _resolveAction(
            id,
            p.requiredTier,
            p.boardVotesFor,
            p.stockholderForBps,
            msg.sender,
            boardVoteWeight[id][msg.sender],
            stockholderVoteWeight[id][msg.sender]
        );

        p.stage = Stage.APPROVED;
        p.amount = finalAmount;
        p.approvedAt = block.timestamp;

        totalApprovedByCategory[p.category] += finalAmount;

        emit ProposalApproved(id, finalAmount, p.requiredTier);
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
    // 4. DISBURSEMENT
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
    // 5. AUDIT
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
    // 6. PUBLIC QUERIES
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
        returns (uint256 proposed, uint256 approved, uint256 disbursed)
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

    /// @notice Whether the required tier is currently satisfied for a proposal.
    function isTierSatisfied(bytes32 id) external view returns (bool) {
        Proposal storage p = proposals[id];
        return meetsThreshold(p.requiredTier, p.boardVotesFor, p.stockholderForBps);
    }
}
