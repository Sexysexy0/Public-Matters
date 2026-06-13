// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title AuthorshipCodex
/// @notice Covenant contract to safeguard rightful authorship and dev identity
contract AuthorshipCodex {
    address public overseer;
    uint256 public recordCount;

    struct AuthorshipRecord {
        uint256 id;
        string author;       // e.g. Emervin V. Gueco (Vinvin)
        string workHash;     // hash of code/document
        string domain;       // dev, governance, creative
        string safeguard;    // copyright, integrity, transparency
        string notes;
        uint256 timestamp;
    }

    mapping(uint256 => AuthorshipRecord) public records;

    event AuthorshipLogged(uint256 indexed id, string author, string workHash, string domain, string safeguard, string notes);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs authorship record
    function logAuthorship(string calldata author, string calldata workHash, string calldata domain, string calldata safeguard, string calldata notes) external onlyOverseer {
        recordCount++;
        records[recordCount] = AuthorshipRecord({
            id: recordCount,
            author: author,
            workHash: workHash,
            domain: domain,
            safeguard: safeguard,
            notes: notes,
            timestamp: block.timestamp
        });
        emit AuthorshipLogged(recordCount, author, workHash, domain, safeguard, notes);
    }

    /// @notice Citizens can view authorship record
    function viewAuthorship(uint256 id) external view returns (AuthorshipRecord memory) {
        return records[id];
    }
}
