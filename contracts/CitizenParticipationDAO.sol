// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title CitizenParticipationDAO
/// @notice Enables citizens to vote and provide feedback on tax policies
contract CitizenParticipationDAO {
    address public oversightCommittee;
    uint256 public proposalCount;

    struct Proposal {
        uint256 id;
        string description;
        uint256 yesVotes;
        uint256 noVotes;
        bool executed;
    }

    mapping(uint256 => Proposal) public proposals;
    mapping(address => mapping(uint256 => bool)) public hasVoted;

    event ProposalCreated(uint256 indexed id, string description);
    event Voted(uint256 indexed id, address indexed voter, bool support);
    event ProposalExecuted(uint256 indexed id, bool passed);

    modifier onlyOversight() {
        require(msg.sender == oversightCommittee, "Not authorized");
        _;
    }

    constructor(address _oversightCommittee) {
        oversightCommittee = _oversightCommittee;
    }

    /// @notice Oversight Committee creates a new proposal
    function createProposal(string calldata description) external onlyOversight {
        proposalCount++;
        proposals[proposalCount] = Proposal({
            id: proposalCount,
            description: description,
            yesVotes: 0,
            noVotes: 0,
            executed: false
        });
        emit ProposalCreated(proposalCount, description);
    }

    /// @notice Citizens vote on proposals
    function vote(uint256 proposalId, bool support) external {
        require(!hasVoted[msg.sender][proposalId], "Already voted");
        Proposal storage p = proposals[proposalId];
        require(!p.executed, "Proposal already executed");

        hasVoted[msg.sender][proposalId] = true;
        if (support) {
            p.yesVotes++;
        } else {
            p.noVotes++;
        }
        emit Voted(proposalId, msg.sender, support);
    }

    /// @notice Oversight executes proposal outcome
    function executeProposal(uint256 proposalId) external onlyOversight {
        Proposal storage p = proposals[proposalId];
        require(!p.executed, "Already executed");
        p.executed = true;
        bool passed = p.yesVotes > p.noVotes;
        emit ProposalExecuted(proposalId, passed);
    }
}
