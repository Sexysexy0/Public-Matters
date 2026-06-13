// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title HabitCleanserDAO
/// @notice DAO covenant for participatory governance of habit cleansing
contract HabitCleanserDAO {
    address public oversightCommittee;
    uint256 public proposalCount;

    struct HabitProposal {
        uint256 id;
        string domain;       // e.g. tech, creative, governance
        string habit;        // unwanted, clean, aligned
        string description;
        uint256 votesFor;
        uint256 votesAgainst;
        bool resolved;
        uint256 timestamp;
    }

    mapping(uint256 => HabitProposal) public proposals;
    mapping(address => mapping(uint256 => bool)) public voted;

    event ProposalCreated(uint256 indexed id, string domain, string habit, string description);
    event Voted(uint256 indexed id, address voter, bool support);
    event ProposalResolved(uint256 indexed id, string domain, string habit, bool passed);

    modifier onlyOversight() {
        require(msg.sender == oversightCommittee, "Not authorized");
        _;
    }

    constructor(address _oversightCommittee) {
        oversightCommittee = _oversightCommittee;
    }

    /// @notice Oversight creates habit cleansing proposal
    function createProposal(string calldata domain, string calldata habit, string calldata description) external onlyOversight {
        proposalCount++;
        proposals[proposalCount] = HabitProposal({
            id: proposalCount,
            domain: domain,
            habit: habit,
            description: description,
            votesFor: 0,
            votesAgainst: 0,
            resolved: false,
            timestamp: block.timestamp
        });
        emit ProposalCreated(proposalCount, domain, habit, description);
    }

    /// @notice Citizens vote on habit proposal
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
        HabitProposal storage p = proposals[id];
        require(!p.resolved, "Already resolved");
        p.resolved = true;
        bool passed = p.votesFor > p.votesAgainst;
        emit ProposalResolved(id, p.domain, p.habit, passed);
    }
}
