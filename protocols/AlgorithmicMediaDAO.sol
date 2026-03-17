// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AlgorithmicMediaDAO {
    struct Proposal {
        string description;
        uint votesFor;
        uint votesAgainst;
        bool executed;
    }

    Proposal[] public proposals;
    mapping(address => bool) public voters;

    event ProposalCreated(uint proposalId, string description);
    event Voted(address indexed voter, uint proposalId, bool support);

    function createProposal(string memory description) public {
        proposals.push(Proposal(description, 0, 0, false));
        emit ProposalCreated(proposals.length - 1, description);
    }

    function vote(uint proposalId, bool support) public {
        require(!voters[msg.sender], "Already voted");
        voters[msg.sender] = true;
        if (support) {
            proposals[proposalId].votesFor++;
        } else {
            proposals[proposalId].votesAgainst++;
        }
        emit Voted(msg.sender, proposalId, support);
    }

    function execute(uint proposalId) public view returns (string memory) {
        Proposal memory p = proposals[proposalId];
        if (p.votesFor > p.votesAgainst) {
            return "Proposal PASSED";
        } else {
            return "Proposal REJECTED";
        }
    }
}
