// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title BlessingDAO
/// @notice Allows stewards to vote on budget reroutes, debt caps, and emotional APR metrics
contract BlessingDAO {
    struct Proposal {
        string description;
        string sector;
        uint256 votes;
        bool executed;
    }

    address public steward;
    mapping(address => bool) public voters;
    Proposal[] public proposals;

    event ProposalCreated(uint256 id, string description, string sector);
    event Voted(address indexed voter, uint256 proposalId);
    event ProposalExecuted(uint256 id, string sector);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    /// @notice Registers a voter
    function registerVoter(address voter) external onlySteward {
        voters[voter] = true;
    }

    /// @notice Creates a reroute proposal
    function createProposal(string memory description, string memory sector) external onlySteward {
        proposals.push(Proposal(description, sector, 0, false));
        emit ProposalCreated(proposals.length - 1, description, sector);
    }

    /// @notice Casts a vote on a proposal
    function vote(uint256 proposalId) external {
        require(voters[msg.sender], "Not a registered voter");
        require(proposalId < proposals.length, "Invalid proposal");
        proposals[proposalId].votes += 1;
        emit Voted(msg.sender, proposalId);
    }

    /// @notice Executes a proposal if it has enough votes
    function executeProposal(uint256 proposalId) external onlySteward {
        Proposal storage p = proposals[proposalId];
        require(!p.executed, "Already executed");
        require(p.votes >= 3, "Not enough votes"); // Threshold can be adjusted
        p.executed = true;
        emit ProposalExecuted(proposalId, p.sector);
    }
}
