// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

interface IOperatorPrivileges {
    function isOperator(address account) external view returns (bool);
}

/// @title ReputationTimelockGovernor
/// @notice Governance framework with reputation-weighted voting and
///         mandatory timelock before execution. Proposals must pass
///         quorum, then wait for the timelock delay before execution.
contract ReputationTimelockGovernor {
    enum ProposalState { Active, Queued, Executed, Cancelled }

    struct Proposal {
        address target;
        uint256 value;
        bytes data;
        string description;
        uint256 votesFor;
        uint256 votesAgainst;
        uint256 queuedAt;
        ProposalState state;
    }

    IOperatorPrivileges public immutable operatorPrivileges;
    uint256 public immutable timelockDelay;

    uint256 public proposalCount;
    uint256 public totalReputation;

    mapping(address => uint256) public reputation;
    mapping(uint256 => Proposal) public proposals;
    mapping(uint256 => mapping(address => bool)) public hasVoted;

    event ProposalCreated(uint256 indexed proposalId, address indexed proposer, address target, string description);
    event ReputationSet(address indexed account, uint256 amount);
    event VoteCast(uint256 indexed proposalId, address indexed voter, bool support, uint256 weight);
    event ProposalQueued(uint256 indexed proposalId, uint256 executeAfter);
    event ProposalExecuted(uint256 indexed proposalId);
    event ProposalCancelled(uint256 indexed proposalId);

    error NotOperator();
    error NotProposer();
    error NotActive();
    error AlreadyVoted();
    error QuorumNotReached();
    error TimelockNotElapsed();
    error NotQueued();
    error AlreadyExecuted();
    error ZeroReputation();

    modifier onlyOperator() {
        if (!operatorPrivileges.isOperator(msg.sender)) revert NotOperator();
        _;
    }

    bool private locked;
    modifier nonReentrant() {
        if (locked) revert();
        locked = true;
        _;
        locked = false;
    }

    constructor(address _operatorPrivileges, uint256 _timelockDelay) {
        operatorPrivileges = IOperatorPrivileges(_operatorPrivileges);
        timelockDelay = _timelockDelay;
    }

    /// @notice Operator sets reputation weight for an account.
    function setReputation(address account, uint256 amount) external onlyOperator {
        uint256 current = reputation[account];
        if (amount > current) {
            totalReputation += (amount - current);
        } else {
            totalReputation -= (current - amount);
        }
        reputation[account] = amount;
        emit ReputationSet(account, amount);
    }

    /// @notice Operator creates a proposal (target call + description).
    function propose(address target, uint256 value, bytes calldata data, string calldata description)
        external onlyOperator returns (uint256 proposalId)
    {
        proposalId = proposalCount++;
        proposals[proposalId] = Proposal({
            target: target,
            value: value,
            data: data,
            description: description,
            votesFor: 0,
            votesAgainst: 0,
            queuedAt: 0,
            state: ProposalState.Active
        });
        emit ProposalCreated(proposalId, msg.sender, target, description);
    }

    /// @notice Operator casts a reputation-weighted vote.
    function vote(uint256 proposalId, bool support) external onlyOperator {
        Proposal storage p = proposals[proposalId];
        if (p.state != ProposalState.Active) revert NotActive();
        if (hasVoted[proposalId][msg.sender]) revert AlreadyVoted();

        uint256 weight = reputation[msg.sender];
        if (weight == 0) revert ZeroReputation();

        hasVoted[proposalId][msg.sender] = true;
        if (support) {
            p.votesFor += weight;
        } else {
            p.votesAgainst += weight;
        }
        emit VoteCast(proposalId, msg.sender, support, weight);
    }

    /// @notice Operator queues a proposal that reached quorum
    ///         (votesFor > votesAgainst and votesFor >= half of total reputation).
    function queue(uint256 proposalId) external onlyOperator {
        Proposal storage p = proposals[proposalId];
        if (p.state != ProposalState.Active) revert NotActive();
        if (p.votesFor <= p.votesAgainst) revert QuorumNotReached();
        if (p.votesFor * 2 < totalReputation) revert QuorumNotReached();

        p.state = ProposalState.Queued;
        p.queuedAt = block.timestamp;
        emit ProposalQueued(proposalId, block.timestamp + timelockDelay);
    }

    /// @notice Operator executes a queued proposal after timelock elapsed.
    function execute(uint256 proposalId) external onlyOperator nonReentrant {
        Proposal storage p = proposals[proposalId];
        if (p.state != ProposalState.Queued) revert NotQueued();
        if (block.timestamp < p.queuedAt + timelockDelay) revert TimelockNotElapsed();

        p.state = ProposalState.Executed;
        (bool ok, ) = p.target.call{value: p.value}(p.data);
        if (!ok) revert();
        emit ProposalExecuted(proposalId);
    }

    /// @notice Operator cancels an active proposal.
    function cancel(uint256 proposalId) external onlyOperator {
        Proposal storage p = proposals[proposalId];
        if (p.state != ProposalState.Active) revert NotActive();
        p.state = ProposalState.Cancelled;
        emit ProposalCancelled(proposalId);
    }

    receive() external payable {}
}
