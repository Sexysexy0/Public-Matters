// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title GovernanceDAO
/// @notice Covenant contract to manage decentralized governance of AI and faith safeguards
contract GovernanceDAO {
    address public founder;
    mapping(address => bool) public members;
    uint256 public proposalCount;

    struct Proposal {
        string title;
        string description;
        uint256 votesFor;
        uint256 votesAgainst;
        bool active;
    }

    mapping(uint256 => Proposal) public proposals;

    event MemberJoined(address member);
    event ProposalCreated(uint256 id, string title, string description);
    event Voted(address voter, uint256 proposalId, bool support);
    event ProposalClosed(uint256 id, string title, uint256 votesFor, uint256 votesAgainst);

    modifier onlyFounder() {
        require(msg.sender == founder, "Not authorized");
        _;
    }

    modifier onlyMember() {
        require(members[msg.sender], "Not a DAO member");
        _;
    }

    constructor() {
        founder = msg.sender;
        members[msg.sender] = true;
    }

    function joinDAO(address newMember) public onlyFounder {
        members[newMember] = true;
        emit MemberJoined(newMember);
    }

    function createProposal(string memory title, string memory description) public onlyMember {
        proposalCount++;
        proposals[proposalCount] = Proposal(title, description, 0, 0, true);
        emit ProposalCreated(proposalCount, title, description);
    }

    function vote(uint256 proposalId, bool support) public onlyMember {
        require(proposals[proposalId].active, "Proposal not active");
        if (support) {
            proposals[proposalId].votesFor++;
        } else {
            proposals[proposalId].votesAgainst++;
        }
        emit Voted(msg.sender, proposalId, support);
    }

    function closeProposal(uint256 proposalId) public onlyFounder {
        require(proposals[proposalId].active, "Proposal already closed");
        proposals[proposalId].active = false;
        emit ProposalClosed(
            proposalId,
            proposals[proposalId].title,
            proposals[proposalId].votesFor,
            proposals[proposalId].votesAgainst
        );
    }
}
