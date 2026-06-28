// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title IntuitionOracleCodex
/// @notice Covenant contract to safeguard communities through intuitive sensing of psychic residue
contract IntuitionOracleCodex {
    address public overseer;
    uint256 public oracleCount;

    struct OracleEntry {
        uint256 id;
        string seer;
        string residue;
        string insight;
        uint256 timestamp;
    }

    mapping(uint256 => OracleEntry) public oracles;

    event OracleLogged(uint256 indexed id, string seer, string insight);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logOracle(
        string calldata seer,
        string calldata residue,
        string calldata insight
    ) external onlyOverseer {
        oracleCount++;
        oracles[oracleCount] = OracleEntry({
            id: oracleCount,
            seer: seer,
            residue: residue,
            insight: insight,
            timestamp: block.timestamp
        });
        emit OracleLogged(oracleCount, seer, insight);
    }

    function viewOracle(uint256 id) external view returns (OracleEntry memory) {
        return oracles[id];
    }
}
