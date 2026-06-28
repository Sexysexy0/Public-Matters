// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title GuardianRotationCodex
/// @notice Covenant contract to safeguard communities through rotation and accountability of security guardians
contract GuardianRotationCodex {
    address public overseer;
    uint256 public rotationCount;

    struct RotationEntry {
        uint256 id;
        string guardian;
        string shift;
        string location;
        uint256 timestamp;
    }

    mapping(uint256 => RotationEntry) public rotations;

    event RotationLogged(uint256 indexed id, string guardian, string shift);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logRotation(
        string calldata guardian,
        string calldata shift,
        string calldata location
    ) external onlyOverseer {
        rotationCount++;
        rotations[rotationCount] = RotationEntry({
            id: rotationCount,
            guardian: guardian,
            shift: shift,
            location: location,
            timestamp: block.timestamp
        });
        emit RotationLogged(rotationCount, guardian, shift);
    }

    function viewRotation(uint256 id) external view returns (RotationEntry memory) {
        return rotations[id];
    }
}
