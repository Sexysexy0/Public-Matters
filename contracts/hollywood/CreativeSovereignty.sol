// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title Creative Sovereignty Pact
/// @notice Allows registered actors to propose and vote on story arcs for mythic cinema
/// @author Scrollchain

contract CreativeSovereignty {
    address public steward;

    struct Proposal {
        string title;
        string synopsis;
        uint256 votes;
        bool active;
    }

    Proposal[] public proposals;
    mapping(address => bool) public registeredActors;
    mapping(address => mapping(uint256 => bool)) public hasVoted;

    event ActorRegistered(address actor);
    event ProposalSubmitted(uint256 id, string title);
    event VoteCast(address actor, uint256 proposalId);

    constructor() {
        steward = msg.sender;
    }

    function registerActor(address actor) public {
        require(msg.sender == steward, "Unauthorized steward");
        registeredActors[actor] = true;
        emit ActorRegistered(actor);
    }

    function submitProposal(string memory title, string memory synopsis) public {
        require(registeredActors[msg.sender], "Not a registered actor");
        proposals.push(Proposal(title, synopsis, 0, true));
        emit ProposalSubmitted(proposals.length - 1, title);
    }

    function voteOnProposal(uint256 proposalId) public {
        require(registeredActors[msg.sender], "Not a registered actor");
        require(proposals[proposalId].active, "Proposal not active");
        require(!hasVoted[msg.sender][proposalId], "Already voted");

        proposals[proposalId].votes += 1;
        hasVoted[msg.sender][proposalId] = true;
        emit VoteCast(msg.sender, proposalId);
    }

    function getProposal(uint256 id) public view returns (string memory, string memory, uint256, bool) {
        Proposal memory p = proposals[id];
        return (p.title, p.synopsis, p.votes, p.active);
    }
}
