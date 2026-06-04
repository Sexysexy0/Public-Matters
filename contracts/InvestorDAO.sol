// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title InvestorDAO
/// @notice Covenant contract for participatory governance in investor-level decisions and asset scaling
contract InvestorDAO {
    address public owner;

    struct Proposal {
        string title;        // e.g. "Scale AI Business", "Expand Asset Network"
        string description;  // details of investor safeguard proposal
        uint256 votesFor;
        uint256 votesAgainst;
        bool active;
        uint256 timestamp;
    }

    uint256 public proposalCount;
    mapping(uint256 => Proposal) public proposals;

    event ProposalCreated(uint256 id, string title, string description, uint256 timestamp);
    event Voted(address voter, uint256 proposalId, bool support);
    event ProposalClosed(uint256 id, string title, uint256 votesFor, uint256 votesAgainst);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /// @notice Create a new investor safeguard proposal
    function createProposal(string memory title, string memory description) public onlyOwner {
        proposalCount++;
        proposals[proposalCount] = Proposal(title, description, 0, 0, true, block.timestamp);
        emit ProposalCreated(proposalCount, title, description, block.timestamp);
    }

    /// @notice Citizens vote on investor proposals
    function vote(uint256 proposalId, bool support) public {
        require(proposals[proposalId].active, "Proposal not active");
        if (support) {
            proposals[proposalId].votesFor++;
        } else {
            proposals[proposalId].votesAgainst++;
        }
        emit Voted(msg.sender, proposalId, support);
    }

    /// @notice Close investor proposal after voting
    function closeProposal(uint256 proposalId) public onlyOwner {
        require(proposals[proposalId].active, "Proposal already closed");
        proposals[proposalId].active = false;
        emit ProposalClosed(
            proposalId,
            proposals[proposalId].title,
            proposals[proposalId].votesFor,
            proposals[proposalId].votesAgainst
        );
    }
}
