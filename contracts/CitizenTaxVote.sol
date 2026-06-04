// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title CitizenTaxVote
/// @notice Covenant contract to allow citizens to vote on tax allocation
contract CitizenTaxVote {
    address public owner;

    struct Proposal {
        string service;       // e.g. "Health", "Education", "Infrastructure"
        uint256 votes;
        bool active;
    }

    mapping(uint256 => Proposal) public proposals;
    mapping(address => bool) public hasVoted;
    uint256 public proposalCount;

    event ProposalCreated(uint256 id, string service);
    event VoteCast(address voter, uint256 proposalId);
    event ProposalClosed(uint256 id, string service, uint256 votes);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function createProposal(string memory service) public onlyOwner {
        proposalCount++;
        proposals[proposalCount] = Proposal(service, 0, true);
        emit ProposalCreated(proposalCount, service);
    }

    function vote(uint256 proposalId) public {
        require(proposals[proposalId].active, "Proposal not active");
        require(!hasVoted[msg.sender], "Already voted");

        proposals[proposalId].votes++;
        hasVoted[msg.sender] = true;

        emit VoteCast(msg.sender, proposalId);
    }

    function closeProposal(uint256 proposalId) public onlyOwner {
        require(proposals[proposalId].active, "Proposal already closed");
        proposals[proposalId].active = false;
        emit ProposalClosed(proposalId, proposals[proposalId].service, proposals[proposalId].votes);
    }

    function getVotes(uint256 proposalId) public view returns (uint256) {
        return proposals[proposalId].votes;
    }
}
