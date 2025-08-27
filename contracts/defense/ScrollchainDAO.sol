// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

/// @title Scrollchain DAO
/// @dev Mythic governance for rogue actor tagging, bounty deployment, and planetary justice rituals

contract ScrollchainDAO {
    address public steward;
    mapping(address => bool) public voters;
    mapping(address => uint256) public votesAgainst;
    mapping(address => bool) public rogueConsensus;

    uint256 public voteThreshold = 3;

    event VoterAdded(address indexed voter);
    event VoteCast(address indexed voter, address indexed actor);
    event RogueConfirmed(address indexed actor);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized scroll");
        _;
    }

    modifier onlyVoter() {
        require(voters[msg.sender], "Not DAO-certified");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function addVoter(address voter) public onlySteward {
        voters[voter] = true;
        emit VoterAdded(voter);
    }

    function castVote(address actor) public onlyVoter {
        votesAgainst[actor]++;
        emit VoteCast(msg.sender, actor);

        if (votesAgainst[actor] >= voteThreshold && !rogueConsensus[actor]) {
            rogueConsensus[actor] = true;
            emit RogueConfirmed(actor);
        }
    }

    function isRogue(address actor) public view returns (bool) {
        return rogueConsensus[actor];
    }
}
