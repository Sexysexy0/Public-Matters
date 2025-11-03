// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MerkleTreeProofLedger {
    address public steward;

    struct MerkleEntry {
        string snapshotDate;
        string assetType;
        string proofHash;
        string emotionalTag;
    }

    MerkleEntry[] public registry;

    event MerkleProofTagged(string snapshotDate, string assetType, string proofHash, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function tagProof(
        string memory snapshotDate,
        string memory assetType,
        string memory proofHash,
        string memory emotionalTag
    ) public onlySteward {
        registry.push(MerkleEntry(snapshotDate, assetType, proofHash, emotionalTag));
        emit MerkleProofTagged(snapshotDate, assetType, proofHash, emotionalTag);
    }
}
