// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title SolutionFocusDAO
/// @notice DAO covenant for governance of work-solution-strategy focus
contract SolutionFocusDAO {
    address public oversightCommittee;
    uint256 public proposalCount;

    struct SolutionProposal {
        uint256 id;
        string domain;       // e.g. tech, governance, creative
        string focus;        // work, solution, strategy
        string restriction;  // no unlawful teachings, no fabrication
        string description;
        uint256 votesFor;
        uint256 votesAgainst;
        bool resolved;
        uint256 timestamp;
    }

    mapping(uint256 => SolutionProposal) public proposals;
    mapping(address => mapping(uint256 => bool)) public voted;

    event ProposalCreated(uint256 indexed id, string domain, string focus, string restriction, string description);
    event Voted(uint256 indexed id, address voter, bool support);
    event ProposalResolved(uint256 indexed id, string domain, string focus, bool passed);

    modifier onlyOversight() {
        require(msg.sender == oversightCommittee, "Not authorized");
        _;
    }

    constructor(address _oversightCommittee) {
        oversightCommittee = _oversightCommittee;
    }

    /// @notice Oversight creates solution focus proposal
    function createProposal(string calldata domain, string calldata focus, string calldata restriction, string calldata description) external onlyOversight {
        proposalCount++;
        proposals[proposalCount] = SolutionProposal({
            id: proposalCount,
            domain: domain,
            focus: focus,
            restriction: restriction,
            description: description,
            votesFor: 0,
            votesAgainst: 0,
            resolved: false,
            timestamp: block.timestamp
        });
        emit ProposalCreated(proposalCount, domain, focus, restriction, description);
    }

    /// @notice Citizens vote on solution proposal
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
        SolutionProposal storage p = proposals[id];
        require(!p.resolved, "Already resolved");
        p.resolved = true;
        bool passed = p.votesFor > p.votesAgainst;
        emit ProposalResolved(id, p.domain, p.focus, passed);
    }
}
