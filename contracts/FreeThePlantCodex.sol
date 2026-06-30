// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title FreeThePlantCodex
/// @notice Covenant contract to symbolically safeguard cannabis legalization, decriminalization, and justice equity
contract FreeThePlantCodex {
    address public overseer;
    uint256 public plantCount;

    struct PlantRule {
        uint256 id;
        string principle; // Legalization, Decriminalization, Justice Equity, Human Dignity, Resource Recognition
        string description; // encoded plant safeguard
        uint256 timestamp;
    }

    mapping(uint256 => PlantRule) public plants;

    event PlantLogged(uint256 indexed id, string principle, string description);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logPlant(
        string calldata principle,
        string calldata description
    ) external onlyOverseer {
        plantCount++;
        plants[plantCount] = PlantRule({
            id: plantCount,
            principle: principle,
            description: description,
            timestamp: block.timestamp
        });
        emit PlantLogged(plantCount, principle, description);
    }

    function viewPlant(uint256 id) external view returns (PlantRule memory) {
        return plants[id];
    }
}
