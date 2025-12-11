// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Voting Power Delegation Protocol Arc
// Prototype contract for proxy voting via smart contracts

contract VotingPowerDelegation {
    struct Vote {
        uint256 proposalId;
        address voter;
        uint256 weight;
        bool choice;
        uint256 timestamp;
    }

    mapping(address => address) public delegates;
    mapping(uint256 => Vote[]) public proposalVotes;
    mapping(address => uint256) public votingWeight;

    address public steward;

    constructor() {
        steward = msg.sender;
        votingWeight[steward] = 100; // initial validator-grade weight
    }

    // Assign voting weight to an address
    function setVotingWeight(address _voter, uint256 _weight) external {
        require(msg.sender == steward, "Only steward can assign weight");
        votingWeight[_voter] = _weight;
    }

    // Delegate voting power
    function delegate(address _to) external {
        delegates[msg.sender] = _to;
    }

    // Cast a vote (direct or delegated)
    function castVote(uint256 _proposalId, bool _choice) external {
        address voter = msg.sender;
        if (delegates[voter] != address(0)) {
            voter = delegates[voter];
        }
        uint256 weight = votingWeight[voter];
        proposalVotes[_proposalId].push(
            Vote(_proposalId, voter, weight, _choice, block.timestamp)
        );
    }

    // Tally votes for a proposal
    function tally(uint256 _proposalId) external view returns (uint256 yes, uint256 no) {
        Vote[] memory votes = proposalVotes[_proposalId];
        for (uint256 i = 0; i < votes.length; i++) {
            if (votes[i].choice) {
                yes += votes[i].weight;
            } else {
                no += votes[i].weight;
            }
        }
    }
}
