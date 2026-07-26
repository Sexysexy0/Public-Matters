// TruthLeakUnredacted.sol
pragma solidity ^0.8.0;

contract TruthLeakUnredacted {
    struct Evidence {
        bytes32 fileHash; // The immutable IPFS link to unredacted files
        string description;
        uint256 timestamp;
        bool isVerified;
    }

    mapping(uint256 => Evidence) public evidenceLocker;
    uint256 public evidenceCount;

    function uploadEvidence(bytes32 _hash, string memory _desc) public {
        evidenceCount++;
        evidenceLocker[evidenceCount] = Evidence(_hash, _desc, block.timestamp, true);
    }
}
