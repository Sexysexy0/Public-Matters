// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ProposalVoting {
    struct Proposal {
        string description;
        uint votesFor;
        uint votesAgainst;
        bool executed;
    }

    Proposal[] public proposals;
    mapping(address => bool) public voters;

    function createProposal(string memory description) public {
        proposals.push(Proposal(description, 0, 0, false));
    }

    function vote(uint proposalId, bool support) public {
        require(!voters[msg.sender], "Already voted");
        voters[msg.sender] = true;
        if (support) {
            proposals[proposalId].votesFor++;
        } else {
            proposals[proposalId].votesAgainst++;
        }
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
