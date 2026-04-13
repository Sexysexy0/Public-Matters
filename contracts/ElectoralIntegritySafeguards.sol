// ElectoralIntegritySafeguards.sol
pragma solidity ^0.8.0;

contract ElectoralIntegritySafeguards {
    struct Ballot {
        bytes32 voteHash;
        uint256 timestamp;
        bool isTallied;
    }

    mapping(uint256 => Ballot) public ballotBox;
    uint256 public totalVotes;

    function castHashedVote(bytes32 _hash) public {
        totalVotes++;
        ballotBox[totalVotes] = Ballot(_hash, block.timestamp, true);
    }

    function verifyInclusion(uint256 _id, bytes32 _hash) public view returns (bool) {
        return (ballotBox[_id].voteHash == _hash);
    }
}
