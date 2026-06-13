// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title IntegrityGuardianDAO
/// @notice DAO covenant for governance of authenticity and integrity safeguards
contract IntegrityGuardianDAO {
    address public oversightCommittee;
    uint256 public proposalCount;

    struct IntegrityProposal {
        uint256 id;
        string domain;       // e.g. tech, governance, creative
        string safeguard;    // authenticity, integrity, lawful alignment
        string description;
        uint256 votesFor;
        uint256 votesAgainst;
        bool resolved;
        uint256 timestamp;
    }

    mapping(uint256 => IntegrityProposal) public proposals;
    mapping(address => mapping(uint256 => bool)) public voted;

    event ProposalCreated(uint256 indexed id, string domain, string safeguard, string description);
    event Voted(uint256 indexed id, address voter, bool support);
    event ProposalResolved(uint256 indexed id, string domain, string safeguard, bool passed);

    modifier onlyOversight() {
        require(msg.sender == oversightCommittee, "Not authorized");
        _;
    }

    constructor(address _oversightCommittee) {
        oversightCommittee = _oversightCommittee;
    }

    /// @notice Oversight creates integrity safeguard proposal
    function createProposal(string calldata domain, string calldata safeguard, string calldata description) external onlyOversight {
        proposalCount++;
        proposals[proposalCount] = IntegrityProposal({
            id: proposalCount,
            domain: domain,
            safeguard: safeguard,
            description: description,
            votesFor: 0,
            votesAgainst: 0,
            resolved: false,
            timestamp: block.timestamp
        });
        emit ProposalCreated(proposalCount, domain, safeguard, description);
    }

    /// @notice Citizens vote on integrity proposal
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
        IntegrityProposal storage p = proposals[id];
        require(!p.resolved, "Already resolved");
        p.resolved = true;
        bool passed = p.votesFor > p.votesAgainst;
        emit ProposalResolved(id, p.domain, p.safeguard, passed);
    }
}
