// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Voting Power Delegation Protocol Arc
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

    event Delegated(address indexed from, address indexed to);
    event Voted(uint256 indexed proposalId, address indexed voter, bool choice, uint256 weight);

    constructor() {
        steward = msg.sender;
        votingWeight[steward] = 100;
    }

    function setVotingWeight(address _voter, uint256 _weight) external {
        require(msg.sender == steward, "Only steward");
        votingWeight[_voter] = _weight;
    }

    function delegate(address _to) external {
        delegates[msg.sender] = _to;
        emit Delegated(msg.sender, _to);
    }

    function castVote(uint256 _proposalId, bool _choice) external {
        address voter = delegates[msg.sender] == address(0) ? msg.sender : delegates[msg.sender];
        uint256 weight = votingWeight[voter];
        proposalVotes[_proposalId].push(Vote(_proposalId, voter, weight, _choice, block.timestamp));
        emit Voted(_proposalId, voter, _choice, weight);
    }

    function tally(uint256 _proposalId) external view returns (uint256 yes, uint256 no) {
        Vote[] memory votes = proposalVotes[_proposalId];
        for (uint256 i = 0; i < votes.length; i++) {
            if (votes[i].choice) yes += votes[i].weight;
            else no += votes[i].weight;
        }
    }
}
