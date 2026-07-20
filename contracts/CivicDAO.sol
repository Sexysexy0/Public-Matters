// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./SammaCodex.sol";

contract CivicDAO {
    SammaCodex public codex;

    struct Proposal {
        uint256 id;
        string description;
        uint256 principleId;
        uint256 votesFor;
        uint256 votesAgainst;
        bool executed;
    }

    uint256 public proposalCount;
    mapping(uint256 => Proposal) public proposals;
    mapping(address => mapping(uint256 => bool)) public hasVoted;

    event ProposalCreated(uint256 id, string description, uint256 principleId);
    event Voted(uint256 proposalId, address voter, bool support);
    event ProposalExecuted(uint256 id, bool passed);

    constructor(address codexAddress) {
        codex = SammaCodex(codexAddress);
    }

    function createProposal(string calldata description, uint256 principleId) external {
        require(codex.isActive(principleId), "Principle not active");
        proposalCount++;
        proposals[proposalCount] = Proposal({
            id: proposalCount,
            description: description,
            principleId: principleId,
            votesFor: 0,
            votesAgainst: 0,
            executed: false
        });
        emit ProposalCreated(proposalCount, description, principleId);
    }

    function vote(uint256 proposalId, bool support) external {
        require(!hasVoted[msg.sender][proposalId], "Already voted");
        hasVoted[msg.sender][proposalId] = true;
        if (support) {
            proposals[proposalId].votesFor++;
        } else {
            proposals[proposalId].votesAgainst++;
        }
        emit Voted(proposalId, msg.sender, support);
    }

    function executeProposal(uint256 proposalId) external {
        Proposal storage p = proposals[proposalId];
        require(!p.executed, "Already executed");
        p.executed = true;
        bool passed = p.votesFor > p.votesAgainst;
        emit ProposalExecuted(proposalId, passed);
    }
}
