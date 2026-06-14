// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title CitizenTrustDAO
/// @notice DAO covenant for participatory governance of citizen trust anchors
contract CitizenTrustDAO {
    address public oversightCommittee;
    uint256 public proposalCount;

    struct TrustProposal {
        uint256 id;
        string anchor;     // e.g. fairness, dignity, transparency
        string safeguard;  // accountability, resilience, equity
        string notes;      // contextual application
        uint256 votesFor;
        uint256 votesAgainst;
        bool resolved;
        uint256 timestamp;
    }

    mapping(uint256 => TrustProposal) public proposals;
    mapping(address => mapping(uint256 => bool)) public voted;

    event ProposalCreated(uint256 indexed id, string anchor, string safeguard, string notes);
    event Voted(uint256 indexed id, address voter, bool support);
    event ProposalResolved(uint256 indexed id, string anchor, bool passed);

    modifier onlyOversight() {
        require(msg.sender == oversightCommittee, "Not authorized");
        _;
    }

    constructor(address _oversightCommittee) {
        oversightCommittee = _oversightCommittee;
    }

    /// @notice Oversight creates trust anchor proposal
    function createProposal(string calldata anchor, string calldata safeguard, string calldata notes) external onlyOversight {
        proposalCount++;
        proposals[proposalCount] = TrustProposal({
            id: proposalCount,
            anchor: anchor,
            safeguard: safeguard,
            notes: notes,
            votesFor: 0,
            votesAgainst: 0,
            resolved: false,
            timestamp: block.timestamp
        });
        emit ProposalCreated(proposalCount, anchor, safeguard, notes);
    }

    /// @notice Citizens vote on trust anchor proposal
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

    /// @notice Oversight resolves trust anchor proposal
    function resolveProposal(uint256 id) external onlyOversight {
        TrustProposal storage p = proposals[id];
        require(!p.resolved, "Already resolved");
        p.resolved = true;
        bool passed = p.votesFor > p.votesAgainst;
        emit ProposalResolved(id, p.anchor, passed);
    }
}
