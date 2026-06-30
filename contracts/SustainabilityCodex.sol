// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title SustainabilityCodex
/// @notice Covenant contract to symbolically safeguard environmental sustainability and resource recognition of cannabis
contract SustainabilityCodex {
    address public overseer;
    uint256 public sustainCount;

    struct SustainRule {
        uint256 id;
        string principle; // Environmental Safeguards, Resource Sustainability, Green Justice, Plant Recognition
        string description; // encoded sustainability safeguard
        uint256 timestamp;
    }

    mapping(uint256 => SustainRule) public sustains;

    event SustainLogged(uint256 indexed id, string principle, string description);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logSustain(
        string calldata principle,
        string calldata description
    ) external onlyOverseer {
        sustainCount++;
        sustains[sustainCount] = SustainRule({
            id: sustainCount,
            principle: principle,
            description: description,
            timestamp: block.timestamp
        });
        emit SustainLogged(sustainCount, principle, description);
    }

    function viewSustain(uint256 id) external view returns (SustainRule memory) {
        return sustains[id];
    }
}
