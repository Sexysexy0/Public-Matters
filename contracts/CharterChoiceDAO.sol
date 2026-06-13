// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title CharterChoiceDAO
/// @notice DAO covenant for participatory governance of school choice and charter models
contract CharterChoiceDAO {
    address public oversightCommittee;
    uint256 public proposalCount;

    struct ChoiceProposal {
        uint256 id;
        string initiative;   // e.g. charter expansion, school choice pilot
        string safeguard;    // fairness, outcomes, transparency
        string notes;        // contextual application
        uint256 votesFor;
        uint256 votesAgainst;
        bool resolved;
        uint256 timestamp;
    }

    mapping(uint256 => ChoiceProposal) public proposals;
    mapping(address => mapping(uint256 => bool)) public voted;

    event ProposalCreated(uint256 indexed id, string initiative, string safeguard, string notes);
    event Voted(uint256 indexed id, address voter, bool support);
    event ProposalResolved(uint256 indexed id, string initiative, bool passed);

    modifier onlyOversight() {
        require(msg.sender == oversightCommittee, "Not authorized");
        _;
    }

    constructor(address _oversightCommittee) {
        oversightCommittee = _oversightCommittee;
    }

    /// @notice Oversight creates school choice proposal
    function createProposal(string calldata initiative, string calldata safeguard, string calldata notes) external onlyOversight {
        proposalCount++;
        proposals[proposalCount] = ChoiceProposal({
            id: proposalCount,
            initiative: initiative,
            safeguard: safeguard,
            notes: notes,
            votesFor: 0,
            votesAgainst: 0,
            resolved: false,
            timestamp: block.timestamp
        });
        emit ProposalCreated(proposalCount, initiative, safeguard, notes);
    }

    /// @notice Citizens vote on school choice proposal
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

    /// @notice Oversight resolves school choice proposal
    function resolveProposal(uint256 id) external onlyOversight {
        ChoiceProposal storage p = proposals[id];
        require(!p.resolved, "Already resolved");
        p.resolved = true;
        bool passed = p.votesFor > p.votesAgainst;
        emit ProposalResolved(id, p.initiative, passed);
    }
}
