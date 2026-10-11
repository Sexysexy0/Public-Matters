// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./OperatorPrivileges.sol";
import "./AIAgentRegistry.sol";
import "./AIDecisionAudit.sol";

/**
 * @title GovernedActionGate
 * @notice N-of-M council approval for high-value AI agent actions.
 *
 * Maps to enterprise treasury governance requirements:
 *   - Proposed actions require quorum approval
 *   - Segregation of duties: proposer cannot approve own proposal
 *   - Value-based auto-exec threshold (small = no approval)
 *   - Every action links to a AIDecisionAudit record
 *   - Full on-chain audit trail
 */
contract GovernedActionGate {
    enum ProposalStatus {
        PENDING,
        APPROVED,
        REJECTED,
        EXECUTED,
        EXPIRED
    }

    struct Proposal {
        uint256 proposalId;
        bytes32 agentId;
        bytes32 decisionId;
        uint256 value;
        string action;
        address proposer;
        uint256 createdAt;
        uint256 expiresAt;
        ProposalStatus status;
        uint256 approvals;
        uint256 rejections;
        mapping(address => bool) hasVoted;
    }

    OperatorPrivileges public privileges;
    AIAgentRegistry public registry;
    AIDecisionAudit public audit;

    mapping(uint256 => Proposal) public proposals;
    uint256 public totalProposals;

    mapping(address => bool) public councilMembers;
    uint256 public councilSize;

    uint256 public approvalThreshold;
    uint256 public autoExecLimit;
    uint256 public proposalTTL;

    event ProposalCreated(uint256 indexed proposalId, bytes32 indexed agentId, uint256 value, address proposer);
    event ProposalApproved(uint256 indexed proposalId, address approver, uint256 totalApprovals);
    event ProposalRejected(uint256 indexed proposalId, address rejector, string reason);
    event ProposalExecuted(uint256 indexed proposalId, bytes32 indexed decisionId);
    event ProposalExpired(uint256 indexed proposalId);
    event CouncilMemberAdded(address indexed member);
    event CouncilMemberRemoved(address indexed member);
    event ThresholdUpdated(uint256 newThreshold);
    event AutoExecLimitUpdated(uint256 newLimit);

    modifier onlyOperator() {
        require(privileges.isOperator(msg.sender), "Not authorized operator");
        _;
    }
    modifier onlyCouncil() {
        require(councilMembers[msg.sender], "Not council member");
        _;
    }
    modifier onlyAdmin() {
        require(msg.sender == privileges.owner(), "Not admin");
        _;
    }
    modifier proposalExists(uint256 id) {
        require(proposals[id].createdAt != 0, "Proposal not found");
        _;
    }

    constructor(address _privileges, address _registry, address _audit, uint256 _threshold, uint256 _ttl) {
        privileges = OperatorPrivileges(_privileges);
        registry = AIAgentRegistry(_registry);
        audit = AIDecisionAudit(_audit);
        approvalThreshold = _threshold;
        proposalTTL = _ttl;
        autoExecLimit = 0;
    }

    // Council management
    function addCouncilMember(address m) external onlyAdmin {
        require(!councilMembers[m], "Already member");
        councilMembers[m] = true;
        councilSize++;
        emit CouncilMemberAdded(m);
    }

    function removeCouncilMember(address m) external onlyAdmin {
        require(councilMembers[m], "Not member");
        councilMembers[m] = false;
        councilSize--;
        emit CouncilMemberRemoved(m);
    }

    function setThreshold(uint256 t) external onlyAdmin {
        require(t > 0 && t <= councilSize, "Invalid threshold");
        approvalThreshold = t;
        emit ThresholdUpdated(t);
    }

    function setAutoExecLimit(uint256 v) external onlyAdmin {
        autoExecLimit = v;
        emit AutoExecLimitUpdated(v);
    }

    // Action lifecycle
    function propose(bytes32 agentId, bytes32 decisionId, uint256 value, string calldata action)
        external
        onlyOperator
        returns (uint256)
    {
        // Intentional: call for its revert side-effect only.
        // forge-lint: disable-next-line(unused-return)
        registry.getAgent(agentId); // reverts if missing

        uint256 id = totalProposals++;
        Proposal storage p = proposals[id];
        p.proposalId = id;
        p.agentId = agentId;
        p.decisionId = decisionId;
        p.value = value;
        p.action = action;
        p.proposer = msg.sender;
        p.createdAt = block.timestamp;
        p.expiresAt = block.timestamp + proposalTTL;

        if (value <= autoExecLimit) {
            p.status = ProposalStatus.EXECUTED;
            emit ProposalCreated(id, agentId, value, msg.sender);
            emit ProposalExecuted(id, decisionId);
            return id;
        }

        p.status = ProposalStatus.PENDING;
        emit ProposalCreated(id, agentId, value, msg.sender);
        return id;
    }

    function approve(uint256 id) external onlyCouncil proposalExists(id) {
        Proposal storage p = proposals[id];
        require(p.status == ProposalStatus.PENDING, "Not pending");
        require(block.timestamp <= p.expiresAt, "Expired");
        require(!p.hasVoted[msg.sender], "Already voted");
        require(msg.sender != p.proposer, "Proposer cannot approve");

        p.hasVoted[msg.sender] = true;
        p.approvals++;

        emit ProposalApproved(id, msg.sender, p.approvals);

        if (p.approvals >= approvalThreshold) {
            p.status = ProposalStatus.APPROVED;
        }
    }

    function reject(uint256 id, string calldata reason) external onlyCouncil proposalExists(id) {
        Proposal storage p = proposals[id];
        require(p.status == ProposalStatus.PENDING, "Not pending");
        require(!p.hasVoted[msg.sender], "Already voted");

        p.hasVoted[msg.sender] = true;
        p.rejections++;
        p.status = ProposalStatus.REJECTED;

        emit ProposalRejected(id, msg.sender, reason);
    }

    function execute(uint256 id) external onlyOperator proposalExists(id) {
        Proposal storage p = proposals[id];
        require(p.status == ProposalStatus.APPROVED, "Not approved");
        p.status = ProposalStatus.EXECUTED;
        emit ProposalExecuted(id, p.decisionId);
    }

    function expire(uint256 id) external proposalExists(id) {
        Proposal storage p = proposals[id];
        require(p.status == ProposalStatus.PENDING, "Not pending");
        require(block.timestamp > p.expiresAt, "Not expired");
        p.status = ProposalStatus.EXPIRED;
        emit ProposalExpired(id);
    }

    function getProposal(uint256 id)
        external
        view
        proposalExists(id)
        returns (
            bytes32 agentId,
            bytes32 decisionId,
            uint256 value,
            string memory action,
            address proposer,
            uint256 createdAt,
            uint256 expiresAt,
            ProposalStatus status,
            uint256 approvals,
            uint256 rejections
        )
    {
        Proposal storage p = proposals[id];
        return (
            p.agentId,
            p.decisionId,
            p.value,
            p.action,
            p.proposer,
            p.createdAt,
            p.expiresAt,
            p.status,
            p.approvals,
            p.rejections
        );
    }
}
