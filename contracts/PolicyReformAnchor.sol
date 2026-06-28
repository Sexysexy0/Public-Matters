// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title PolicyReformAnchor
/// @notice Covenant contract to anchor and record policy reforms for governance correction
contract PolicyReformAnchor {
    address public overseer;
    uint256 public reformCount;

    struct ReformEntry {
        uint256 id;
        string policyName;
        string oldLogicHash;
        string newLogicHash;
        string author;
        string notes;
        uint256 timestamp;
    }

    mapping(uint256 => ReformEntry) public reforms;

    event PolicyReformed(uint256 indexed id, string policyName, string author, string notes);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logReform(
        string calldata policyName,
        string calldata oldLogicHash,
        string calldata newLogicHash,
        string calldata author,
        string calldata notes
    ) external onlyOverseer {
        reformCount++;
        reforms[reformCount] = ReformEntry({
            id: reformCount,
            policyName: policyName,
            oldLogicHash: oldLogicHash,
            newLogicHash: newLogicHash,
            author: author,
            notes: notes,
            timestamp: block.timestamp
        });
        emit PolicyReformed(reformCount, policyName, author, notes);
    }

    function viewReform(uint256 id) external view returns (ReformEntry memory) {
        return reforms[id];
    }
}
