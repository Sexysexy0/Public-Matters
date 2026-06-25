// SPDX-License-Identifier: MIT
// SequelDAO.sol
// Purpose: Fan-governed DAO for approving sequels and casting arcs
// Author: Vinvin (Validator-grade steward)
// Date: May 29, 2026

pragma solidity ^0.8.0;

contract SequelDAO {
    struct Proposal {
        string description;
        uint256 votesFor;
        uint256 votesAgainst;
        bool executed;
    }

    address public steward;
    Proposal[] public proposals;
    mapping(address => bool) public members;

    event ProposalCreated(uint256 proposalId, string description);
    event Voted(uint256 proposalId, address voter, bool support);
    event Executed(uint256 proposalId);

    constructor() {
        steward = msg.sender;
        members[steward] = true;
    }

    function addMember(address _member) public {
        require(msg.sender == steward, "Only steward can add members");
        members[_member] = true;
    }

    function createProposal(string memory _desc) public {
        require(members[msg.sender], "Only members can propose");
        proposals.push(Proposal(_desc, 0, 0, false));
        emit ProposalCreated(proposals.length - 1, _desc);
    }

    function vote(uint256 proposalId, bool support) public {
        require(members[msg.sender], "Only members can vote");
        require(!proposals[proposalId].executed, "Already executed");
        if (support) {
            proposals[proposalId].votesFor += 1;
        } else {
            proposals[proposalId].votesAgainst += 1;
        }
        emit Voted(proposalId, msg.sender, support);
    }

    function executeProposal(uint256 proposalId) public {
        require(msg.sender == steward, "Only steward can execute");
        require(!proposals[proposalId].executed, "Already executed");
        proposals[proposalId].executed = true;
        emit Executed(proposalId);
    }
}
