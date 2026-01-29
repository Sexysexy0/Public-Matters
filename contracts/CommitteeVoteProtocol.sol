pragma solidity ^0.8.20;

contract CommitteeVoteProtocol {
    address public admin;

    struct Vote {
        string committee;    // e.g. Finance, Appropriations
        string decision;     // e.g. Approved, Rejected
        uint256 timestamp;
    }

    Vote[] public votes;

    event VoteLogged(string committee, string decision, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logVote(string calldata committee, string calldata decision) external onlyAdmin {
        votes.push(Vote(committee, decision, block.timestamp));
        emit VoteLogged(committee, decision, block.timestamp);
    }

    function totalVotes() external view returns (uint256) {
        return votes.length;
    }
}
