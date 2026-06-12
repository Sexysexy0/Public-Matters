// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title CommunityFundDAO
/// @notice DAO for allocating refund escrow to community projects
contract CommunityFundDAO {
    address public oversightCommittee;
    uint256 public proposalCount;

    struct Proposal {
        uint256 id;
        string description;
        uint256 fundAmount;
        uint256 yesVotes;
        uint256 noVotes;
        bool executed;
    }

    mapping(uint256 => Proposal) public proposals;
    mapping(address => mapping(uint256 => bool)) public hasVoted;

    event ProposalCreated(uint256 indexed id, string description, uint256 fundAmount);
    event Voted(uint256 indexed id, address indexed voter, bool support);
    event ProposalExecuted(uint256 indexed id, bool passed);

    modifier onlyOversight() {
        require(msg.sender == oversightCommittee, "Not authorized");
        _;
    }

    constructor(address _oversightCommittee) {
        oversightCommittee = _oversightCommittee;
    }

    /// @notice Oversight Committee creates community fund proposal
    function createProposal(string calldata description, uint256 fundAmount) external onlyOversight {
        proposalCount++;
        proposals[proposalCount] = Proposal({
            id: proposalCount,
            description: description,
            fundAmount: fundAmount,
            yesVotes: 0,
            noVotes: 0,
            executed: false
        });
        emit ProposalCreated(proposalCount, description, fundAmount);
    }

    /// @notice Citizens vote on community fund proposals
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
