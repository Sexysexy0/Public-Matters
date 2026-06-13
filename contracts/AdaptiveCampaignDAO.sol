// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title AdaptiveCampaignDAO
/// @notice DAO covenant for participatory governance of adaptive campaigns
contract AdaptiveCampaignDAO {
    address public oversightCommittee;
    uint256 public proposalCount;

    struct CampaignProposal {
        uint256 id;
        string objective;    // e.g. adapt tactics, shift strategy, long-term vision
        string safeguard;    // flexibility, creativity, rationality
        string notes;        // contextual application
        uint256 votesFor;
        uint256 votesAgainst;
        bool resolved;
        uint256 timestamp;
    }

    mapping(uint256 => CampaignProposal) public proposals;
    mapping(address => mapping(uint256 => bool)) public voted;

    event ProposalCreated(uint256 indexed id, string objective, string safeguard, string notes);
    event Voted(uint256 indexed id, address voter, bool support);
    event ProposalResolved(uint256 indexed id, string objective, bool passed);

    modifier onlyOversight() {
        require(msg.sender == oversightCommittee, "Not authorized");
        _;
    }

    constructor(address _oversightCommittee) {
        oversightCommittee = _oversightCommittee;
    }

    /// @notice Oversight creates adaptive campaign proposal
    function createProposal(string calldata objective, string calldata safeguard, string calldata notes) external onlyOversight {
        proposalCount++;
        proposals[proposalCount] = CampaignProposal({
            id: proposalCount,
            objective: objective,
            safeguard: safeguard,
            notes: notes,
            votesFor: 0,
            votesAgainst: 0,
            resolved: false,
            timestamp: block.timestamp
        });
        emit ProposalCreated(proposalCount, objective, safeguard, notes);
    }

    /// @notice Citizens vote on adaptive campaign proposal
    function vote(uint256 id, bool support) external {
        require(!voted[msg.sender][id], "Already voted");
        require(!proposals[id].resolved, "Proposal resolved");

        voted[msg.sender][id] = true;
        if (support) {
            proposals[id].votesFor++;
        } else {
            proposals[id].votesAgainst++;
        }
        emit Voted(id, msg.sender, support);
    }

    /// @notice Oversight resolves adaptive campaign proposal
    function resolveProposal(uint256 id) external onlyOversight {
        CampaignProposal storage p = proposals[id];
        require(!p.resolved, "Already resolved");
        p.resolved = true;
        bool passed = p.votesFor > p.votesAgainst;
        emit ProposalResolved(id, p.objective, passed);
    }
}
