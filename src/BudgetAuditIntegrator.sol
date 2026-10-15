// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./OperatorPrivileges.sol";
import "./AIDecisionAudit.sol";
import "./BudgetDeliberationRegistry.sol";
import "./TieredApproval.sol";

/**
 * @title BudgetAuditIntegrator
 * @notice Bridges BudgetDeliberationRegistry to AIDecisionAudit.
 *
 * Access model: ANY registered operator may audit budget events.
 * No single-owner bottleneck.
 *
 * IMPORTANT: This contract must itself be registered as an operator in
 * OperatorPrivileges before use — it calls audit.recordDecision() as
 * itself, so msg.sender at the audit layer is this contract.
 *
 * Every budget lifecycle event is written to AIDecisionAudit with the
 * governing authority tier embedded in the outputHash. That makes the
 * authority level (OPERATOR / MAJORITY / SUPERMAJORITY / UNANIMOUS)
 * a permanent, queryable part of the record.
 */
contract BudgetAuditIntegrator {
    OperatorPrivileges public immutable privileges;
    AIDecisionAudit public immutable audit;
    BudgetDeliberationRegistry public immutable budget;

    uint256 public totalAudited;

    event BudgetEventAudited(
        bytes32 indexed proposalId,
        bytes32 indexed decisionId,
        string eventType,
        uint8 confidence,
        uint8 tier,
        address indexed operator
    );

    modifier onlyOperator() {
        require(privileges.isOperator(msg.sender), "Not an operator");
        _;
    }

    constructor(address _privileges, address _audit, address _budget) {
        require(_privileges != address(0), "privileges=0");
        require(_audit != address(0), "audit=0");
        require(_budget != address(0), "budget=0");

        privileges = OperatorPrivileges(_privileges);
        audit = AIDecisionAudit(_audit);
        budget = BudgetDeliberationRegistry(_budget);
    }

    function auditBudgetEvent(bytes32 proposalId, string calldata eventType, uint8 confidence)
        external
        onlyOperator
        returns (bytes32)
    {
        require(confidence <= 100, "Confidence must be 0-100");

        BudgetDeliberationRegistry.Proposal memory p = budget.getProposal(proposalId);

        return _record(proposalId, eventType, confidence, uint8(p.requiredTier), p);
    }

    function auditFullLifecycle(bytes32 proposalId) external onlyOperator returns (bytes32) {
        BudgetDeliberationRegistry.Proposal memory p = budget.getProposal(proposalId);

        uint8 confidence = 0;
        uint256 total = p.votesFor + p.votesAgainst;
        if (total > 0) {
            confidence = uint8((p.votesFor * 100) / total);
        }

        return _record(proposalId, _stageName(p.stage), confidence, uint8(p.requiredTier), p);
    }

    function _record(
        bytes32 proposalId,
        string memory eventType,
        uint8 confidence,
        uint8 tier,
        BudgetDeliberationRegistry.Proposal memory p
    ) internal returns (bytes32) {
        bytes32 inputHash = keccak256(abi.encode(p.title, p.category, p.amount, p.proposer, p.createdAt));

        bytes32 reasoningHash = keccak256(abi.encode(p.votesFor, p.votesAgainst, p.deliberationHash));

        bytes32 outputHash = keccak256(abi.encode(eventType, tier, uint256(p.stage), p.disbursedAmount, p.auditHash));

        bytes32 agentId = keccak256(abi.encodePacked("BUDGET", address(budget)));

        bytes32 decisionId = audit.recordDecision(agentId, inputHash, reasoningHash, outputHash, confidence);

        totalAudited++;

        // Event carries decisionId, which is the return value of the call
        // above; reordering would require dropping the audit link.
        // forge-lint: disable-next-line(reentrancy-events)
        emit BudgetEventAudited(proposalId, decisionId, eventType, confidence, tier, msg.sender);
        return decisionId;
    }

    function _stageName(BudgetDeliberationRegistry.Stage s) internal pure returns (string memory) {
        if (s == BudgetDeliberationRegistry.Stage.PROPOSED) return "PROPOSED";
        if (s == BudgetDeliberationRegistry.Stage.DELIBERATING) return "DELIBERATING";
        if (s == BudgetDeliberationRegistry.Stage.APPROVED) return "APPROVED";
        if (s == BudgetDeliberationRegistry.Stage.REJECTED) return "REJECTED";
        if (s == BudgetDeliberationRegistry.Stage.DISBURSING) return "DISBURSING";
        if (s == BudgetDeliberationRegistry.Stage.COMPLETED) return "COMPLETED";
        if (s == BudgetDeliberationRegistry.Stage.AUDITED) return "AUDITED";
        return "UNKNOWN";
    }

    function getBudgetAuditTrail() external view returns (bytes32[] memory) {
        bytes32 agentId = keccak256(abi.encodePacked("BUDGET", address(budget)));
        return audit.getDecisionsByAgent(agentId);
    }

    function getBudgetAuditCount() external view returns (uint256) {
        bytes32 agentId = keccak256(abi.encodePacked("BUDGET", address(budget)));
        return audit.getDecisionCount(agentId);
    }
}
