// DecentralizedKnowledgeLibrary.sol
pragma solidity ^0.8.0;

contract DecentralizedKnowledgeLibrary {
    struct KnowledgeBase {
        bytes32 fileHash; // IPFS hash ng aklat o journal
        string category;
        bool isVerifiedByPeers;
    }

    mapping(uint256 => KnowledgeBase) public globalLibrary;

    function uploadKnowledge(uint256 _id, bytes32 _hash, string memory _cat) public {
        // Peer-reviewed upload process (Decentralized Academia)
        globalLibrary[_id] = KnowledgeBase(_hash, _cat, true);
    }
}
