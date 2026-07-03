// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title GuardRotationLedger
/// @notice Covenant contract to safeguard schools by enforcing guard rotation and vigilance
contract GuardRotationLedger {
    address public overseer;
    uint256 public rotationCount;

    struct RotationEntry {
        uint256 id;
        string guardName;
        string shift;
        string location;
        uint256 timestamp;
    }

    mapping(uint256 => RotationEntry) public rotations;

    event RotationLogged(uint256 indexed id, string guardName, string shift);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logRotation(
        string calldata guardName,
        string calldata shift,
        string calldata location
    ) external onlyOverseer {
        rotationCount++;
        rotations[rotationCount] = RotationEntry({
            id: rotationCount,
            guardName: guardName,
            shift: shift,
            location: location,
            timestamp: block.timestamp
        });
        emit RotationLogged(rotationCount, guardName, shift);
    }

    function viewRotation(uint256 id) external view returns (RotationEntry memory) {
        return rotations[id];
    }
}
