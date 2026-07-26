// OpenSourceIntelligenceProtocol.sol
pragma solidity ^0.8.0;

contract OpenSourceIntelligenceProtocol {
    struct Blueprint {
        bytes32 dataHash;
        string category;
        bool isPublicDomain;
    }

    mapping(bytes32 => Blueprint) public library;

    function releaseToPublic(bytes32 _hash, string memory _cat) public {
        // Enforced transparency: Invention belongs to the collective.
        library[_hash] = Blueprint(_hash, _cat, true);
    }
}
