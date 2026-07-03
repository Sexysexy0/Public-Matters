// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title RiverGuardian
/// @notice Covenant to safeguard river rehabilitation,
///         ensuring clean rivers, flood control, and ecological balance.
contract RiverGuardian {
    address public overseer;
    uint256 public guardianCount;

    struct Guardian {
        uint256 id;
        string initiative;   // CleanRivers, FloodControl, EcoBalance
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => Guardian) public guardians;

    event GuardianDeclared(uint256 indexed id, string initiative, string description);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function declareGuardian(string calldata initiative, string calldata description) external onlyOverseer {
        guardianCount++;
        guardians[guardianCount] = Guardian(guardianCount, initiative, description, block.timestamp);
        emit GuardianDeclared(guardianCount, initiative, description);
    }

    function viewGuardian(uint256 id) external view returns (Guardian memory) {
        return guardians[id];
    }
}
