// AntiDeepfakeRegistry.sol
pragma solidity ^0.8.0;

contract AntiDeepfakeRegistry {
    struct ContentHash {
        bytes32 mediaHash;
        address creator;
        uint256 timestamp;
        bool isVerified;
    }

    mapping(bytes32 => ContentHash) public registry;

    function registerContent(bytes32 _hash) public {
        registry[_hash] = ContentHash(_hash, msg.sender, block.timestamp, true);
    }

    function verifyContent(bytes32 _hash) public view returns (bool) {
        return registry[_hash].isVerified;
    }
}
