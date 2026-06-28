// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title JusticeEquityCodex
/// @notice Covenant contract to encode systemic justice and equity safeguards
contract JusticeEquityCodex {
    address public overseer;
    uint256 public codexCount;

    struct JusticeEntry {
        uint256 id;
        string principle;
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => JusticeEntry) public entries;

    event JusticeLogged(uint256 indexed id, string principle, string description);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logJustice(
        string calldata principle,
        string calldata description
    ) external onlyOverseer {
        codexCount++;
        entries[codexCount] = JusticeEntry({
            id: codexCount,
            principle: principle,
            description: description,
            timestamp: block.timestamp
        });
        emit JusticeLogged(codexCount, principle, description);
    }

    function viewJustice(uint256 id) external view returns (JusticeEntry memory) {
        return entries[id];
    }
}
