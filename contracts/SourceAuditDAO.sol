// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title SourceAuditDAO
/// @notice DAO covenant for participatory auditing of industry sources
contract SourceAuditDAO {
    address public oversightCommittee;
    uint256 public proposalCount;

    struct AuditProposal {
        uint256 id;
        string industry;     // e.g. business, movie, music
        string source;       // source identifier
        string issue;        // reliability, compliance, manipulation
        uint256 votesFor;
        uint256 votesAgainst;
        bool resolved;
        uint256 timestamp;
    }

    mapping(uint256 => AuditProposal) public proposals;
    mapping(address => mapping(uint256 => bool)) public voted;

    event ProposalCreated(uint256 indexed id, string industry, string source, string issue);
    event Voted(uint256 indexed id, address voter, bool support);
    event ProposalResolved(uint256 indexed id, string industry, string source, string issue, bool passed);

    modifier onlyOversight() {
        require(msg.sender == oversightCommittee, "Not authorized");
        _;
    }

    constructor(address _oversightCommittee) {
        oversightCommittee = _oversightCommittee;
    }

    /// @notice Oversight creates audit proposal
    function createProposal(string calldata industry, string calldata source, string calldata issue) external onlyOversight {
        proposalCount++;
        proposals[proposalCount] = AuditProposal({
            id: proposalCount,
            industry: industry,
            source: source,
            issue: issue,
            votesFor: 0,
            votesAgainst: 0,
            resolved: false,
            timestamp: block.timestamp
        });
        emit ProposalCreated(proposalCount, industry, source, issue);
    }

    /// @notice Citizens vote on audit proposal
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
        AuditProposal storage p = proposals[id];
        require(!p.resolved, "Already resolved");
        p.resolved = true;
        bool passed = p.votesFor > p.votesAgainst;
        emit ProposalResolved(id, p.industry, p.source, p.issue, passed);
    }
}
