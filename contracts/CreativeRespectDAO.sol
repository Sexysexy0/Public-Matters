// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title CreativeRespectDAO
/// @notice DAO covenant for participatory governance of respect and freedom balance
contract CreativeRespectDAO {
    address public oversightCommittee;
    uint256 public proposalCount;

    struct RespectProposal {
        uint256 id;
        string industry;       // e.g. music, movie, anime
        string representation; // self-driven, collective, hybrid
        string description;
        uint256 votesFor;
        uint256 votesAgainst;
        bool resolved;
        uint256 timestamp;
    }

    mapping(uint256 => RespectProposal) public proposals;
    mapping(address => mapping(uint256 => bool)) public voted;

    event ProposalCreated(uint256 indexed id, string industry, string representation, string description);
    event Voted(uint256 indexed id, address voter, bool support);
    event ProposalResolved(uint256 indexed id, string industry, string representation, bool passed);

    modifier onlyOversight() {
        require(msg.sender == oversightCommittee, "Not authorized");
        _;
    }

    constructor(address _oversightCommittee) {
        oversightCommittee = _oversightCommittee;
    }

    /// @notice Oversight creates respect proposal
    function createProposal(string calldata industry, string calldata representation, string calldata description) external onlyOversight {
        proposalCount++;
        proposals[proposalCount] = RespectProposal({
            id: proposalCount,
            industry: industry,
            representation: representation,
            description: description,
            votesFor: 0,
            votesAgainst: 0,
            resolved: false,
            timestamp: block.timestamp
        });
        emit ProposalCreated(proposalCount, industry, representation, description);
    }

    /// @notice Citizens vote on respect proposal
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

    /// @notice Oversight resolves proposal
    function resolveProposal(uint256 id) external onlyOversight {
        RespectProposal storage p = proposals[id];
        require(!p.resolved, "Already resolved");
        p.resolved = true;
        bool passed = p.votesFor > p.votesAgainst;
        emit ProposalResolved(id, p.industry, p.representation, passed);
    }
}
