// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title PatienceCodex
/// @notice Covenant contract to safeguard systemic endurance, principled patience, and dignified perseverance
contract PatienceCodex {
    address public overseer;
    uint256 public patienceCount;

    struct PatienceRule {
        uint256 id;
        string principle; // Endurance, Waiting, Perseverance, Calm
        string description; // encoded patience safeguard
        uint256 timestamp;
    }

    mapping(uint256 => PatienceRule) public patiences;

    event PatienceLogged(uint256 indexed id, string principle, string description);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logPatience(
        string calldata principle,
        string calldata description
    ) external onlyOverseer {
        patienceCount++;
        patiences[patienceCount] = PatienceRule({
            id: patienceCount,
            principle: principle,
            description: description,
            timestamp: block.timestamp
        });
        emit PatienceLogged(patienceCount, principle, description);
    }

    function viewPatience(uint256 id) external view returns (PatienceRule memory) {
        return patiences[id];
    }
}
