// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title TransparencyDAO
/// @notice DAO covenant for participatory governance of fiscal transparency
contract TransparencyDAO {
    address public oversightCommittee;
    uint256 public proposalCount;

    struct TransparencyProposal {
        uint256 id;
        string measure;     // e.g. public ledger, audit disclosure, citizen report
        string safeguard;   // fairness, accountability, openness
        string notes;       // contextual application
        uint256 votesFor;
        uint256 votesAgainst;
        bool resolved;
        uint256 timestamp;
    }

    mapping(uint256 => TransparencyProposal) public proposals;
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

    /// @notice Oversight creates transparency proposal
    function createProposal(string calldata measure, string calldata safeguard, string calldata notes) external onlyOversight {
        proposalCount++;
        proposals[proposalCount] = TransparencyProposal({
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

    /// @notice Citizens vote on transparency proposal
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

    /// @notice Oversight resolves transparency proposal
    function resolveProposal(uint256 id) external onlyOversight {
        TransparencyProposal storage p = proposals[id];
        require(!p.resolved, "Already resolved");
        p.resolved = true;
        bool passed = p.votesFor > p.votesAgainst;
        emit ProposalResolved(id, p.measure, passed);
    }
}
