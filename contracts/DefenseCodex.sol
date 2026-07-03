// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title DefenseCodex
/// @notice Covenant contract to safeguard systemic military cooperation, collective security, and dignified defense
contract DefenseCodex {
    address public overseer;
    uint256 public defenseCount;

    struct DefenseRule {
        uint256 id;
        string principle; // Cooperation, Security, Protection, Alliance
        string description; // encoded defense safeguard
        uint256 timestamp;
    }

    mapping(uint256 => DefenseRule) public defenses;

    event DefenseLogged(uint256 indexed id, string principle, string description);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logDefense(
        string calldata principle,
        string calldata description
    ) external onlyOverseer {
        defenseCount++;
        defenses[defenseCount] = DefenseRule({
            id: defenseCount,
            principle: principle,
            description: description,
            timestamp: block.timestamp
        });
        emit DefenseLogged(defenseCount, principle, description);
    }

    function viewDefense(uint256 id) external view returns (DefenseRule memory) {
        return defenses[id];
    }
}
