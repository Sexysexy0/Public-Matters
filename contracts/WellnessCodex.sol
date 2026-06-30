// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title WellnessCodex
/// @notice Covenant contract to symbolically safeguard holistic wellness, lifestyle recognition, and therapeutic equity
contract WellnessCodex {
    address public overseer;
    uint256 public wellnessCount;

    struct WellnessRule {
        uint256 id;
        string principle; // Holistic Wellness, Lifestyle Safeguards, Therapeutic Equity, Human Dignity
        string description; // encoded wellness safeguard
        uint256 timestamp;
    }

    mapping(uint256 => WellnessRule) public wellness;

    event WellnessLogged(uint256 indexed id, string principle, string description);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logWellness(
        string calldata principle,
        string calldata description
    ) external onlyOverseer {
        wellnessCount++;
        wellness[wellnessCount] = WellnessRule({
            id: wellnessCount,
            principle: principle,
            description: description,
            timestamp: block.timestamp
        });
        emit WellnessLogged(wellnessCount, principle, description);
    }

    function viewWellness(uint256 id) external view returns (WellnessRule memory) {
        return wellness[id];
    }
}
