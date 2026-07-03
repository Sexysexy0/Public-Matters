// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title AtmosphericResidueCodex
/// @notice Covenant contract to safeguard communities through encoding psychic miasma and environmental shifts
contract AtmosphericResidueCodex {
    address public overseer;
    uint256 public residueCount;

    struct ResidueEntry {
        uint256 id;
        string source;
        string nature;
        string insight;
        uint256 timestamp;
    }

    mapping(uint256 => ResidueEntry) public residues;

    event ResidueLogged(uint256 indexed id, string source, string nature);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logResidue(
        string calldata source,
        string calldata nature,
        string calldata insight
    ) external onlyOverseer {
        residueCount++;
        residues[residueCount] = ResidueEntry({
            id: residueCount,
            source: source,
            nature: nature,
            insight: insight,
            timestamp: block.timestamp
        });
        emit ResidueLogged(residueCount, source, nature);
    }

    function viewResidue(uint256 id) external view returns (ResidueEntry memory) {
        return residues[id];
    }
}
