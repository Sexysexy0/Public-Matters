// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title HashRegistry
/// @notice Tamper-evident registry for document hashes (store only hashes/CIDs)
contract HashRegistry {
    event DocumentRegistered(bytes32 indexed docHash, address indexed registrar, uint256 timestamp, string tag);

    function register(bytes32 docHash, string calldata tag) external {
        emit DocumentRegistered(docHash, msg.sender, block.timestamp, tag);
    }
}
