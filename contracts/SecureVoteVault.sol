// SecureVoteVault.sol
pragma solidity ^0.8.0;

contract SecureVoteVault {
    struct Candidate {
        uint256 id;
        string name;
        uint256 voteCount;
    }

    mapping(uint256 => Candidate) public candidates;
    mapping(address => bool) public hasVoted;
    uint256 public totalVotes;

    function castVote(uint256 _candidateId) public {
        require(!hasVoted[msg.sender], "Identity already used for voting.");
        candidates[_candidateId].voteCount++;
        hasVoted[msg.sender] = true;
        totalVotes++;
    }
}
