// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title DecisionProofDAO
/// @notice DAO covenant for proof-based decision governance
contract DecisionProofDAO {
    address public oversightCommittee;
    uint256 public proposalCount;

    struct ProofProposal {
        uint256 id;
        string domain;       // governance, strategy, creative
        string method;       // axioms, reductio, dependency chains, proof by cases
        string restriction;  // no fabrication, no unlawful teaching
        string description;
        uint256 votesFor;
        uint256 votesAgainst;
        bool resolved;
        uint256 timestamp;
    }

    mapping(uint256 => ProofProposal) public proposals;
    mapping(address => mapping(uint256 => bool)) public voted;

    event ProposalCreated(uint256 indexed id, string domain, string method, string restriction, string description);
    event Voted(uint256 indexed id, address voter, bool support);
    event ProposalResolved(uint256 indexed id, string domain, string method, bool passed);

    modifier onlyOversight() {
        require(msg.sender == oversightCommittee, "Not authorized");
        _;
    }

    constructor(address _oversightCommittee) {
        oversightCommittee = _oversightCommittee;
    }

    /// @notice Oversight creates proof-based governance proposal
    function createProposal(string calldata domain, string calldata method, string calldata restriction, string calldata description) external onlyOversight {
        proposalCount++;
        proposals[proposalCount] = ProofProposal({
            id: proposalCount,
            domain: domain,
            method: method,
            restriction: restriction,
            description: description,
            votesFor: 0,
            votesAgainst: 0,
            resolved: false,
            timestamp: block.timestamp
        });
        emit ProposalCreated(proposalCount, domain, method, restriction, description);
    }

    /// @notice Citizens vote on proof proposal
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
        ProofProposal storage p = proposals[id];
        require(!p.resolved, "Already resolved");
        p.resolved = true;
        bool passed = p.votesFor > p.votesAgainst;
        emit ProposalResolved(id, p.domain, p.method, passed);
    }
}
