// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title OversightGuardianDAO
/// @notice DAO covenant for participatory governance of compliance guardrails
contract OversightGuardianDAO {
    address public oversightCommittee;
    uint256 public proposalCount;

    struct GovernanceProposal {
        uint256 id;
        string guardrail;    // e.g. compliance fence, deployment bridge
        string description;  // details of the guardrail
        uint256 votesFor;
        uint256 votesAgainst;
        bool resolved;
        uint256 timestamp;
    }

    mapping(uint256 => GovernanceProposal) public proposals;
    mapping(address => mapping(uint256 => bool)) public voted;

    event ProposalCreated(uint256 indexed id, string guardrail, string description);
    event Voted(uint256 indexed id, address voter, bool support);
    event ProposalResolved(uint256 indexed id, string guardrail, bool passed);

    modifier onlyOversight() {
        require(msg.sender == oversightCommittee, "Not authorized");
        _;
    }

    constructor(address _oversightCommittee) {
        oversightCommittee = _oversightCommittee;
    }

    /// @notice Oversight creates governance proposal
    function createProposal(string calldata guardrail, string calldata description) external onlyOversight {
        proposalCount++;
        proposals[proposalCount] = GovernanceProposal({
            id: proposalCount,
            guardrail: guardrail,
            description: description,
            votesFor: 0,
            votesAgainst: 0,
            resolved: false,
            timestamp: block.timestamp
        });
        emit ProposalCreated(proposalCount, guardrail, description);
    }

    /// @notice Citizens vote on governance proposal
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
        GovernanceProposal storage p = proposals[id];
        require(!p.resolved, "Already resolved");
        p.resolved = true;
        bool passed = p.votesFor > p.votesAgainst;
        emit ProposalResolved(id, p.guardrail, passed);
    }
}
