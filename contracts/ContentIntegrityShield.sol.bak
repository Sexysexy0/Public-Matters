// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title ContentIntegrityShield
/// @notice Covenant contract to safeguard human-generated content
contract ContentIntegrityShield {
    struct Content {
        address creator;
        string uri;
        uint256 timestamp;
        bool verifiedHuman;
    }

    mapping(bytes32 => Content) public registry;

    event ContentRegistered(bytes32 indexed hash, address indexed creator, string uri, bool verifiedHuman);

    /// @notice Register content with human verification
    function registerContent(string memory uri, bool verifiedHuman) public {
        bytes32 hash = keccak256(abi.encodePacked(uri, msg.sender, block.timestamp));
        registry[hash] = Content(msg.sender, uri, block.timestamp, verifiedHuman);
        emit ContentRegistered(hash, msg.sender, uri, verifiedHuman);
    }

    /// @notice Verify if content is human-generated
    function isHuman(bytes32 hash) public view returns (bool) {
        return registry[hash].verifiedHuman;
    }
}
