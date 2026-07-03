// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title BirdMysteryCodex
/// @notice Covenant contract to safeguard communities through encoding the chaotic archetype of birds
contract BirdMysteryCodex {
    address public overseer;
    uint256 public birdCount;

    struct BirdEntry {
        uint256 id;
        string species;
        string symbolism;
        string frequency;
        uint256 timestamp;
    }

    mapping(uint256 => BirdEntry) public birds;

    event BirdLogged(uint256 indexed id, string species, string symbolism);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logBird(
        string calldata species,
        string calldata symbolism,
        string calldata frequency
    ) external onlyOverseer {
        birdCount++;
        birds[birdCount] = BirdEntry({
            id: birdCount,
            species: species,
            symbolism: symbolism,
            frequency: frequency,
            timestamp: block.timestamp
        });
        emit BirdLogged(birdCount, species, symbolism);
    }

    function viewBird(uint256 id) external view returns (BirdEntry memory) {
        return birds[id];
    }
}
