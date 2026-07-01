// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title ClarityCodex
/// @notice Covenant contract to safeguard systemic transparency, principled clarity, and dignified illumination
contract ClarityCodex {
    address public overseer;
    uint256 public clarityCount;

    struct ClarityRule {
        uint256 id;
        string principle; // Transparency, Illumination, Simplicity, Truth
        string description; // encoded clarity safeguard
        uint256 timestamp;
    }

    mapping(uint256 => ClarityRule) public clarities;

    event ClarityLogged(uint256 indexed id, string principle, string description);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logClarity(
        string calldata principle,
        string calldata description
    ) external onlyOverseer {
        clarityCount++;
        clarities[clarityCount] = ClarityRule({
            id: clarityCount,
            principle: principle,
            description: description,
            timestamp: block.timestamp
        });
        emit ClarityLogged(clarityCount, principle, description);
    }

    function viewClarity(uint256 id) external view returns (ClarityRule memory) {
        return clarities[id];
    }
}
