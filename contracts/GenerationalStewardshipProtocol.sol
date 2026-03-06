// GenerationalStewardshipProtocol.sol
pragma solidity ^0.8.0;

contract GenerationalStewardshipProtocol {
    struct Commitment {
        uint256 id;
        string resource;   // e.g. "Forests"
        string pledge;     // e.g. "Preserve for future generations"
        uint256 timestamp;
    }

    uint256 public commitmentCount;
    mapping(uint256 => Commitment) public commitments;

    event CommitmentLogged(uint256 id, string resource, string pledge);

    function logCommitment(string memory resource, string memory pledge) public {
        commitmentCount++;
        commitments[commitmentCount] = Commitment(commitmentCount, resource, pledge, block.timestamp);
        emit CommitmentLogged(commitmentCount, resource, pledge);
    }
}
