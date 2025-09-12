// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract NarrativeEquityOracle {
    struct EquitySignal {
        uint256 id;
        string region;
        string genre;
        uint256 representationScore;
        string recommendation;
        uint256 timestamp;
    }

    mapping(uint256 => EquitySignal) public equityRegistry;
    uint256 public equityCount;

    event EquityLogged(uint256 id, string region, string genre, uint256 score);

    function logEquity(
        string memory region,
        string memory genre,
        uint256 representationScore,
        string memory recommendation,
        uint256 timestamp
    ) public {
        equityRegistry[equityCount] = EquitySignal(
            equityCount,
            region,
            genre,
            representationScore,
            recommendation,
            timestamp
        );
        emit EquityLogged(equityCount, region, genre, representationScore);
        equityCount++;
    }

    function getEquity(uint256 id) public view returns (EquitySignal memory) {
        return equityRegistry[id];
    }
}
