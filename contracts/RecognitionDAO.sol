// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title RecognitionDAO
/// @notice DAO covenant for participatory governance of recognition and attribution
contract RecognitionDAO {
    address public oversightCommittee;
    uint256 public proposalCount;

    struct RecognitionProposal {
        uint256 id;
        string nominee;      // e.g. Emervin V. Gueco (Vinvin)
        string project;      // project/repo name
        string proofHash;    // hash of code/doc commit
        string rationale;    // why recognition is deserved
        uint256 votesFor;
        uint256 votesAgainst;
        bool resolved;
        uint256 timestamp;
    }

    mapping(uint256 => RecognitionProposal) public proposals;
    mapping(address => mapping(uint256 => bool)) public voted;

    event ProposalCreated(uint256 indexed id, string nominee, string project, string proofHash, string rationale);
    event Voted(uint256 indexed id, address voter, bool support);
    event ProposalResolved(uint256 indexed id, string nominee, string project, bool passed);

    modifier onlyOversight() {
        require(msg.sender == oversightCommittee, "Not authorized");
        _;
    }

    constructor(address _oversightCommittee) {
        oversightCommittee = _oversightCommittee;
    }

    /// @notice Oversight creates recognition proposal
    function createProposal(string calldata nominee, string calldata project, string calldata proofHash, string calldata rationale) external onlyOversight {
        proposalCount++;
        proposals[proposalCount] = RecognitionProposal({
            id: proposalCount,
            nominee: nominee,
            project: project,
            proofHash: proofHash,
            rationale: rationale,
            votesFor: 0,
            votesAgainst: 0,
            resolved: false,
            timestamp: block.timestamp
        });
        emit ProposalCreated(proposalCount, nominee, project, proofHash, rationale);
    }

    /// @notice Citizens vote on recognition proposal
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

    /// @notice Oversight resolves recognition proposal
    function resolveProposal(uint256 id) external onlyOversight {
        RecognitionProposal storage p = proposals[id];
        require(!p.resolved, "Already resolved");
        p.resolved = true;
        bool passed = p.votesFor > p.votesAgainst;
        emit ProposalResolved(id, p.nominee, p.project, passed);
    }
}
