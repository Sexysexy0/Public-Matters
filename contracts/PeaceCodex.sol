// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title PeaceCodex
/// @notice Covenant contract to safeguard systemic harmony, conflict resolution, and dignified peace
contract PeaceCodex {
    address public overseer;
    uint256 public peaceCount;

    struct PeaceRule {
        uint256 id;
        string principle; // Harmony, Conflict Resolution, Nonviolence, Reconciliation
        string description; // encoded peace safeguard
        uint256 timestamp;
    }

    mapping(uint256 => PeaceRule) public peaces;

    event PeaceLogged(uint256 indexed id, string principle, string description);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logPeace(
        string calldata principle,
        string calldata description
    ) external onlyOverseer {
        peaceCount++;
        peaces[peaceCount] = PeaceRule({
            id: peaceCount,
            principle: principle,
            description: description,
            timestamp: block.timestamp
        });
        emit PeaceLogged(peaceCount, principle, description);
    }

    function viewPeace(uint256 id) external view returns (PeaceRule memory) {
        return peaces[id];
    }
}
