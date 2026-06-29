// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title GuardianshipCodex
/// @notice Covenant contract to safeguard communities through systemic anchoring of guardianship safeguards
contract GuardianshipCodex {
    address public overseer;
    uint256 public guardianshipCount;

    struct GuardianshipEntry {
        uint256 id;
        string child;
        string guardian;
        string authority;
        uint256 timestamp;
    }

    mapping(uint256 => GuardianshipEntry) public guardianships;

    event GuardianshipLogged(uint256 indexed id, string child, string guardian, string authority);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logGuardianship(
        string calldata child,
        string calldata guardian,
        string calldata authority
    ) external onlyOverseer {
        guardianshipCount++;
        guardianships[guardianshipCount] = GuardianshipEntry({
            id: guardianshipCount,
            child: child,
            guardian: guardian,
            authority: authority,
            timestamp: block.timestamp
        });
        emit GuardianshipLogged(guardianshipCount, child, guardian, authority);
    }

    function viewGuardianship(uint256 id) external view returns (GuardianshipEntry memory) {
        return guardianships[id];
    }
}
