// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title ValveCouncil
/// @notice DAO-style council for voting on Valve sovereign safeguards
/// @dev Collective governance for principles, revenue flows, and shadow audits

contract ValveCouncil {
    address public chair;
    uint256 public proposalCount;

    struct Proposal {
        uint256 id;
        string subject;   // e.g., "Small Team Principle", "Revenue Flow Allocation", "Shadow Audit Report"
        string action;    // e.g., "Adopt Principle", "Allocate Revenue", "Publish Audit"
        uint256 votesFor;
        uint256 votesAgainst;
        uint256 timestamp;
        bool executed;
    }

    mapping(uint256 => Proposal) public proposals;
    mapping(address => mapping(uint256 => bool)) public hasVoted;

    event ProposalCreated(uint256 id, string subject, string action, uint256 timestamp);
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

    /// @notice Create a new proposal for Valve sovereign governance
    function createProposal(string calldata subject, string calldata action) external onlyChair {
        proposalCount++;
        proposals[proposalCount] = Proposal(proposalCount, subject, action, 0, 0, block.timestamp, false);
        emit ProposalCreated(proposalCount, subject, action, block.timestamp);
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
