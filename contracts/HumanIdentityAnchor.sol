// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title HumanIdentityAnchor
/// @notice Covenant contract to establish decentralized proof-of-humanity
contract HumanIdentityAnchor {
    address public overseer;
    uint256 public identityCount;

    struct IdentityRecord {
        uint256 id;
        string name;
        string publicKey;
        string proofHash;
        uint256 timestamp;
    }

    mapping(uint256 => IdentityRecord) public records;

    event IdentityAnchored(uint256 indexed id, string name, string publicKey, string proofHash);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function anchorIdentity(
        string calldata name,
        string calldata publicKey,
        string calldata proofHash
    ) external onlyOverseer {
        identityCount++;
        records[identityCount] = IdentityRecord({
            id: identityCount,
            name: name,
            publicKey: publicKey,
            proofHash: proofHash,
            timestamp: block.timestamp
        });
        emit IdentityAnchored(identityCount, name, publicKey, proofHash);
    }

    function viewIdentity(uint256 id) external view returns (IdentityRecord memory) {
        return records[id];
    }
}
