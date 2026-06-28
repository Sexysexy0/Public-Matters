// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title GovernanceCodex
/// @notice Master covenant to bundle authorship, transparency, and identity safeguards
contract GovernanceCodex {
    address public overseer;
    uint256 public codexCount;

    struct CodexEntry {
        uint256 id;
        string category;
        address contractAddress;
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => CodexEntry) public codexEntries;

    event CodexRegistered(uint256 indexed id, string category, address contractAddress, string description);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function registerCodex(
        string calldata category,
        address contractAddress,
        string calldata description
    ) external onlyOverseer {
        codexCount++;
        codexEntries[codexCount] = CodexEntry({
            id: codexCount,
            category: category,
            contractAddress: contractAddress,
            description: description,
            timestamp: block.timestamp
        });
        emit CodexRegistered(codexCount, category, contractAddress, description);
    }

    function viewCodex(uint256 id) external view returns (CodexEntry memory) {
        return codexEntries[id];
    }
}
