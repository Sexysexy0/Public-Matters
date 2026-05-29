// Copyright (c) 2026 Vinvin. All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title StreamerBondDAO
 * @dev Governance DAO contract to expand StreamerBondPrototype into full voting + equity resonance system.
 * Arc: gameplay depth → humor resonance → balanced representation → community feedback → voting equity → communal foresight
 */
contract StreamerBondDAO {
    address public steward;
    uint256 public proposalCount;

    struct Proposal {
        uint256 id;
        string description;
        uint256 votesFor;
        uint256 votesAgainst;
        bool executed;
    }

    mapping(uint256 => Proposal) public proposals;
    mapping(address => bool) public members;
    mapping(address => mapping(uint256 => bool)) public hasVoted;

    event MemberJoined(address member);
    event ProposalCreated(uint256 id, string description);
    event Voted(address member, uint256 proposalId, bool support);
    event ProposalExecuted(uint256 id, bool passed);

    modifier onlySteward() {
        require(msg.sender == steward, "Not authorized");
        _;
    }

    modifier onlyMember() {
        require(members[msg.sender], "Not a DAO member");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    /// @dev Steward approves new DAO members
    function joinDAO(address _member) external onlySteward {
        members[_member] = true;
        emit MemberJoined(_member);
    }

    /// @dev Create a new proposal
    function createProposal(string calldata _description) external onlyMember {
        proposalCount++;
        proposals[proposalCount] = Proposal(proposalCount, _description, 0, 0, false);
        emit ProposalCreated(proposalCount, _description);
    }

    /// @dev Vote on a proposal
    function vote(uint256 _proposalId, bool support) external onlyMember {
        require(!hasVoted[msg.sender][_proposalId], "Already voted");
        Proposal storage proposal = proposals[_proposalId];
        require(!proposal.executed, "Proposal already executed");

        hasVoted[msg.sender][_proposalId] = true;
        if (support) {
            proposal.votesFor++;
        } else {
            proposal.votesAgainst++;
        }
        emit Voted(msg.sender, _proposalId, support);
    }

    /// @dev Steward executes proposal after voting
    function executeProposal(uint256 _proposalId) external onlySteward {
        Proposal storage proposal = proposals[_proposalId];
        require(!proposal.executed, "Already executed");

        proposal.executed = true;
        bool passed = proposal.votesFor > proposal.votesAgainst;
        emit ProposalExecuted(_proposalId, passed);
    }
}
