// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title CrisisAdaptationDAO
/// @notice DAO covenant for participatory governance of crisis adaptation and resilience
contract CrisisAdaptationDAO {
    address public oversightCommittee;
    uint256 public proposalCount;

    struct AdaptationProposal {
        uint256 id;
        string crisis;     // e.g. pandemic, financial collapse, geopolitical shock
        string safeguard;  // resilience, continuity, trust endurance
        string principle;  // fairness, dignity, accountability
        string notes;      // contextual application
        uint256 votesFor;
        uint256 votesAgainst;
        bool resolved;
        uint256 timestamp;
    }

    mapping(uint256 => AdaptationProposal) public proposals;
    mapping(address => mapping(uint256 => bool)) public voted;

    event ProposalCreated(uint256 indexed id, string crisis, string safeguard, string principle, string notes);
    event Voted(uint256 indexed id, address voter, bool support);
    event ProposalResolved(uint256 indexed id, string crisis, bool passed);

    modifier onlyOversight() {
        require(msg.sender == oversightCommittee, "Not authorized");
        _;
    }

    constructor(address _oversightCommittee) {
        oversightCommittee = _oversightCommittee;
    }

    /// @notice Oversight creates crisis adaptation proposal
    function createProposal(string calldata crisis, string calldata safeguard, string calldata principle, string calldata notes) external onlyOversight {
        proposalCount++;
        proposals[proposalCount] = AdaptationProposal({
            id: proposalCount,
            crisis: crisis,
            safeguard: safeguard,
            principle: principle,
            notes: notes,
            votesFor: 0,
            votesAgainst: 0,
            resolved: false,
            timestamp: block.timestamp
        });
        emit ProposalCreated(proposalCount, crisis, safeguard, principle, notes);
    }

    /// @notice Citizens vote on crisis adaptation proposal
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

    /// @notice Oversight resolves crisis adaptation proposal
    function resolveProposal(uint256 id) external onlyOversight {
        AdaptationProposal storage p = proposals[id];
        require(!p.resolved, "Already resolved");
        p.resolved = true;
        bool passed = p.votesFor > p.votesAgainst;
        emit ProposalResolved(id, p.crisis, passed);
    }
}
