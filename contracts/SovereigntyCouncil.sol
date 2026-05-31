// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title SovereigntyCouncil
/// @notice DAO-style council for voting on Golden Pill sovereignty principles
/// @dev Collective governance for applying SovereigntyShield principles

contract SovereigntyCouncil {
    address public chair;
    uint256 public proposalCount;

    struct Proposal {
        uint256 id;
        string principle; // e.g., "Family Business", "Bitcoin Asset", "Truthfulness"
        string action;    // e.g., "Adopt", "Reject", "Audit"
        uint256 votesFor;
        uint256 votesAgainst;
        uint256 timestamp;
        bool executed;
    }

    mapping(uint256 => Proposal) public proposals;
    mapping(address => mapping(uint256 => bool)) public hasVoted;

    event ProposalCreated(uint256 id, string principle, string action, uint256 timestamp);
    event Voted(uint256 id, address voter, bool support, uint256 timestamp);
    event ProposalExecuted(uint256 id, string action, uint256 timestamp);

    modifier onlyChair() {
        require(msg.sender == chair, "Not authorized");
        _;
    }

    constructor(address _chair) {
        chair = _chair;
        proposalCount = 0;
    }

    /// @notice Create a new proposal for a principle
    function createProposal(string calldata principle, string calldata action) external onlyChair {
        proposalCount++;
        proposals[proposalCount] = Proposal(proposalCount, principle, action, 0, 0, block.timestamp, false);
        emit ProposalCreated(proposalCount, principle, action, block.timestamp);
    }

    /// @notice Vote on a proposal
    function vote(uint256 id, bool support) external {
        require(!hasVoted[msg.sender][id], "Already voted");
        require(!proposals[id].executed, "Proposal already executed");

        hasVoted[msg.sender][id] = true;
        if (support) {
            proposals[id].votesFor++;
        } else {
            proposals[id].votesAgainst++;
        }
        emit Voted(id, msg.sender, support, block.timestamp);
    }

    /// @notice Execute proposal if majority supports
    function executeProposal(uint256 id) external onlyChair {
        Proposal storage p = proposals[id];
        require(!p.executed, "Already executed");
        require(p.votesFor > p.votesAgainst, "Not enough support");

        p.executed = true;
        emit ProposalExecuted(id, p.action, block.timestamp);
    }
}
