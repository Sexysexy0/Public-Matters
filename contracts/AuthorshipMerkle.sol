// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title AuthorshipMerkle
/// @notice Covenant contract to safeguard authorship via Merkle tree commitments
contract AuthorshipMerkle {
    address public overseer;
    bytes32 public rootHash;   // Merkle root commitment
    uint256 public registeredAt;

    event RootCommitted(bytes32 indexed rootHash, uint256 timestamp);
    event ProofVerified(address indexed verifier, bytes32 leaf, bool valid);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer, bytes32 _rootHash) {
        overseer = _overseer;
        rootHash = _rootHash;
        registeredAt = block.timestamp;
        emit RootCommitted(_rootHash, block.timestamp);
    }

    /// @notice Update the Merkle root (only overseer)
    function updateRoot(bytes32 _newRoot) external onlyOverseer {
        rootHash = _newRoot;
        registeredAt = block.timestamp;
        emit RootCommitted(_newRoot, block.timestamp);
    }

    /// @notice Verify a leaf against the stored Merkle root
    /// @param leaf Hash of the contract file (keccak256)
    /// @param proof Array of sibling hashes from leaf to root
    /// @param index Position of the leaf in the tree
    function verifyProof(bytes32 leaf, bytes32[] calldata proof, uint256 index) external returns (bool) {
        bytes32 computedHash = leaf;
        for (uint256 i = 0; i < proof.length; i++) {
            if (index % 2 == 0) {
                computedHash = keccak256(abi.encodePacked(computedHash, proof[i]));
            } else {
                computedHash = keccak256(abi.encodePacked(proof[i], computedHash));
            }
            index = index / 2;
        }
        bool valid = (computedHash == rootHash);
        emit ProofVerified(msg.sender, leaf, valid);
        return valid;
    }
}
