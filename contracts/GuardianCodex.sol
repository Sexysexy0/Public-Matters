// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title GuardianCodex
/// @notice Covenant contract to safeguard systemic protection, defense, and dignified guardianship
contract GuardianCodex {
    address public overseer;
    uint256 public guardianCount;

    struct GuardianRule {
        uint256 id;
        string principle; // Protection, Defense, Guardianship, Shielding the People
        string description; // encoded guardian safeguard
        uint256 timestamp;
    }

    mapping(uint256 => GuardianRule) public guardians;

    event GuardianLogged(uint256 indexed id, string principle, string description);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logGuardian(
        string calldata principle,
        string calldata description
    ) external onlyOverseer {
        guardianCount++;
        guardians[guardianCount] = GuardianRule({
            id: guardianCount,
            principle: principle,
            description: description,
            timestamp: block.timestamp
        });
        emit GuardianLogged(guardianCount, principle, description);
    }

    function viewGuardian(uint256 id) external view returns (GuardianRule memory) {
        return guardians[id];
    }
}
