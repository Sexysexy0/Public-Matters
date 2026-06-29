// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title GuardianshipCodex
/// @notice Covenant contract to safeguard communities through systemic anchoring of guardianship practices
contract GuardianshipCodex {
    address public overseer;
    uint256 public guardianshipCount;

    struct GuardianshipEntry {
        uint256 id;
        string actor;
        string context;
        string principle;
        uint256 timestamp;
    }

    mapping(uint256 => GuardianshipEntry) public guardians;

    event GuardianshipLogged(uint256 indexed id, string actor, string context);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logGuardianship(
        string calldata actor,
        string calldata context,
        string calldata principle
    ) external onlyOverseer {
        guardianshipCount++;
        guardians[guardianshipCount] = GuardianshipEntry({
            id: guardianshipCount,
            actor: actor,
            context: context,
            principle: principle,
            timestamp: block.timestamp
        });
        emit GuardianshipLogged(guardianshipCount, actor, context);
    }

    function viewGuardianship(uint256 id) external view returns (GuardianshipEntry memory) {
        return guardians[id];
    }
}
