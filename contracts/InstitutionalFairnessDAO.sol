// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title InstitutionalFairnessDAO
/// @notice DAO covenant for participatory governance of fairness safeguards across institutions
contract InstitutionalFairnessDAO {
    address public oversightCommittee;
    uint256 public proposalCount;

    struct FairnessProposal {
        uint256 id;
        string safeguard;    // e.g. equity, dignity, transparency
        string domain;       // education, judiciary, corporate governance
        string notes;        // contextual application
        uint256 votesFor;
        uint256 votesAgainst;
        bool resolved;
        uint256 timestamp;
    }

    mapping(uint256 => FairnessProposal) public proposals;
    mapping(address => mapping(uint256 => bool)) public voted;

    event ProposalCreated(uint256 indexed id, string safeguard, string domain, string notes);
    event Voted(uint256 indexed id, address voter, bool support);
    event ProposalResolved(uint256 indexed id, string safeguard, bool passed);

    modifier onlyOversight() {
        require(msg.sender == oversightCommittee, "Not authorized");
        _;
    }

    constructor(address _oversightCommittee) {
        oversightCommittee = _oversightCommittee;
    }

    /// @notice Oversight creates fairness safeguard proposal
    function createProposal(string calldata safeguard, string calldata domain, string calldata notes) external onlyOversight {
        proposalCount++;
        proposals[proposalCount] = FairnessProposal({
            id: proposalCount,
            safeguard: safeguard,
            domain: domain,
            notes: notes,
            votesFor: 0,
            votesAgainst: 0,
            resolved: false,
            timestamp: block.timestamp
        });
        emit ProposalCreated(proposalCount, safeguard, domain, notes);
    }

    /// @notice Citizens vote on fairness safeguard proposal
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

    /// @notice Oversight resolves fairness safeguard proposal
    function resolveProposal(uint256 id) external onlyOversight {
        FairnessProposal storage p = proposals[id];
        require(!p.resolved, "Already resolved");
        p.resolved = true;
        bool passed = p.votesFor > p.votesAgainst;
        emit ProposalResolved(id, p.safeguard, passed);
    }
}
