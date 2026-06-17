// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title EntropyCommentsCodex
/// @notice Covenant to encode Shannon entropy insights and community reflections for Vinvin's governance arc
contract EntropyCommentsCodex {
    address public overseer;
    uint256 public recordCount;

    struct CommentRecord {
        uint256 id;
        string domain;      // entropy, compression, prediction, governance, community
        string safeguard;   // authenticity clause, intelligence clause, accountability clause
        string notes;       // contextual application
        uint256 timestamp;
    }

    mapping(uint256 => CommentRecord) public records;

    event CommentLogged(uint256 indexed id, string domain, string safeguard);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs entropy comment record
    function logComment(string calldata domain, string calldata safeguard, string calldata notes) external onlyOverseer {
        recordCount++;
        records[recordCount] = CommentRecord({
            id: recordCount,
            domain: domain,
            safeguard: safeguard,
            notes: notes,
            timestamp: block.timestamp
        });
        emit CommentLogged(recordCount, domain, safeguard);
    }

    /// @notice Citizens can view entropy comment records
    function viewComment(uint256 id) external view returns (CommentRecord memory) {
        return records[id];
    }
}
