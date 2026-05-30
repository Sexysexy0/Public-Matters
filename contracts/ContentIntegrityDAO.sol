// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title ContentIntegrityDAO
/// @notice DAO governance for safeguarding human-generated content
contract ContentIntegrityDAO {
    struct Proposal {
        uint256 id;
        address proposer;
        string description;
        uint256 voteCountHuman;
        uint256 voteCountSynthetic;
        bool executed;
    }

    mapping(uint256 => Proposal) public proposals;
    mapping(uint256 => mapping(address => bool)) public hasVoted;
    uint256 public proposalCounter;

    event ProposalCreated(uint256 id, address proposer, string description);
    event Voted(uint256 id, address voter, bool voteHuman);
    event ProposalExecuted(uint256 id, bool outcomeHuman);

    /// @notice Create a new proposal for content integrity
    function createProposal(string memory description) public {
        proposalCounter++;
        proposals[proposalCounter] = Proposal(
            proposalCounter,
            msg.sender,
            description,
            0,
            0,
            false
        );
        emit ProposalCreated(proposalCounter, msg.sender, description);
    }

    /// @notice Vote on a proposal: true = human content, false = synthetic
    function vote(uint256 proposalId, bool voteHuman) public {
        require(!hasVoted[proposalId][msg.sender], "Already voted");
        Proposal storage p = proposals[proposalId];
        require(!p.executed, "Proposal already executed");

        hasVoted[proposalId][msg.sender] = true;
        if (voteHuman) {
            p.voteCountHuman++;
        } else {
            p.voteCountSynthetic++;
        }
        emit Voted(proposalId, msg.sender, voteHuman);
    }

    /// @notice Execute proposal outcome
    function executeProposal(uint256 proposalId) public {
        Proposal storage p = proposals[proposalId];
        require(!p.executed, "Already executed");
        p.executed = true;

        bool outcomeHuman = p.voteCountHuman > p.voteCountSynthetic;
        emit ProposalExecuted(proposalId, outcomeHuman);
    }
}
