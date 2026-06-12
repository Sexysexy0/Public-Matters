// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title CommunityResilienceDAO
/// @notice DAO covenant for participatory resilience projects
contract CommunityResilienceDAO {
    address public oversightCommittee;
    uint256 public proposalCount;

    struct ResilienceProposal {
        uint256 id;
        string description;
        uint256 fundAmount;
        uint256 yesVotes;
        uint256 noVotes;
        bool executed;
        uint256 timestamp;
    }

    mapping(uint256 => ResilienceProposal) public proposals;
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

    /// @notice Oversight Committee creates resilience proposal
    function createProposal(string calldata description, uint256 fundAmount) external onlyOversight {
        proposalCount++;
        proposals[proposalCount] = ResilienceProposal({
            id: proposalCount,
            description: description,
            fundAmount: fundAmount,
            yesVotes: 0,
            noVotes: 0,
            executed: false,
            timestamp: block.timestamp
        });
        emit ProposalCreated(proposalCount, description, fundAmount);
    }

    /// @notice Citizens vote on resilience proposals
    function vote(uint256 proposalId, bool support) external {
        require(!hasVoted[msg.sender][proposalId], "Already voted");
        ResilienceProposal storage p = proposals[proposalId];
        require(!p.executed, "Already executed");

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
        ResilienceProposal storage p = proposals[proposalId];
        require(!p.executed, "Already executed");
        p.executed = true;
        bool passed = p.yesVotes > p.noVotes;
        emit ProposalExecuted(proposalId, passed);
    }
}
