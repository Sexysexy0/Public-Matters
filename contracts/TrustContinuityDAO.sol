// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title TrustContinuityDAO
/// @notice DAO covenant to sustain citizen trust across governance cycles
contract TrustContinuityDAO {
    address public oversightCommittee;
    uint256 public proposalCount;

    struct TrustProposal {
        uint256 id;
        string measure;     // e.g. continuity safeguard, transparency ritual, equity anchor
        string safeguard;   // fairness, dignity, accountability
        string notes;       // contextual application
        uint256 votesFor;
        uint256 votesAgainst;
        bool resolved;
        uint256 timestamp;
    }

    mapping(uint256 => TrustProposal) public proposals;
    mapping(address => mapping(uint256 => bool)) public voted;

    event ProposalCreated(uint256 indexed id, string measure, string safeguard, string notes);
    event Voted(uint256 indexed id, address voter, bool support);
    event ProposalResolved(uint256 indexed id, string measure, bool passed);

    modifier onlyOversight() {
        require(msg.sender == oversightCommittee, "Not authorized");
        _;
    }

    constructor(address _oversightCommittee) {
        oversightCommittee = _oversightCommittee;
    }

    /// @notice Oversight creates trust continuity proposal
    function createProposal(string calldata measure, string calldata safeguard, string calldata notes) external onlyOversight {
        proposalCount++;
        proposals[proposalCount] = TrustProposal({
            id: proposalCount,
            measure: measure,
            safeguard: safeguard,
            notes: notes,
            votesFor: 0,
            votesAgainst: 0,
            resolved: false,
            timestamp: block.timestamp
        });
        emit ProposalCreated(proposalCount, measure, safeguard, notes);
    }

    /// @notice Citizens vote on trust continuity proposal
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

    /// @notice Oversight resolves trust continuity proposal
    function resolveProposal(uint256 id) external onlyOversight {
        TrustProposal storage p = proposals[id];
        require(!p.resolved, "Already resolved");
        p.resolved = true;
        bool passed = p.votesFor > p.votesAgainst;
        emit ProposalResolved(id, p.measure, passed);
    }
}
