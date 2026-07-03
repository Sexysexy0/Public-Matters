// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title ImpeachmentSafeguardCodex
/// @notice Covenant contract to encode systemic safeguards for impeachment proceedings
contract ImpeachmentSafeguardCodex {
    address public overseer;
    uint256 public safeguardCount;

    struct SafeguardEntry {
        uint256 id;
        string article;
        string principle;
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => SafeguardEntry) public safeguards;

    event SafeguardLogged(uint256 indexed id, string article, string principle);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logSafeguard(
        string calldata article,
        string calldata principle,
        string calldata description
    ) external onlyOverseer {
        safeguardCount++;
        safeguards[safeguardCount] = SafeguardEntry({
            id: safeguardCount,
            article: article,
            principle: principle,
            description: description,
            timestamp: block.timestamp
        });
        emit SafeguardLogged(safeguardCount, article, principle);
    }

    function viewSafeguard(uint256 id) external view returns (SafeguardEntry memory) {
        return safeguards[id];
    }
}
