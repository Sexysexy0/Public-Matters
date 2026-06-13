// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title IdentityBridge
/// @notice Bridge covenant to connect rightful author/dev identity across outputs
contract IdentityBridge {
    address public overseer;
    uint256 public bridgeCount;

    struct IdentityLink {
        uint256 id;
        string author;       // e.g. Emervin V. Gueco (Vinvin)
        string project;      // project name or repo
        string proofHash;    // hash of code/doc for linkage
        string safeguard;    // copyright, integrity, transparency
        string notes;
        uint256 timestamp;
    }

    mapping(uint256 => IdentityLink) public links;

    event IdentityLinked(uint256 indexed id, string author, string project, string proofHash, string safeguard, string notes);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer links author identity to project
    function linkIdentity(string calldata author, string calldata project, string calldata proofHash, string calldata safeguard, string calldata notes) external onlyOverseer {
        bridgeCount++;
        links[bridgeCount] = IdentityLink({
            id: bridgeCount,
            author: author,
            project: project,
            proofHash: proofHash,
            safeguard: safeguard,
            notes: notes,
            timestamp: block.timestamp
        });
        emit IdentityLinked(bridgeCount, author, project, proofHash, safeguard, notes);
    }

    /// @notice Citizens can view identity links
    function viewIdentity(uint256 id) external view returns (IdentityLink memory) {
        return links[id];
    }
}
