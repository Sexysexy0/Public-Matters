// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title WeaponDetectionOracle
/// @notice Covenant contract to safeguard schools by detecting weapons and contraband
contract WeaponDetectionOracle {
    address public overseer;
    uint256 public detectionCount;

    struct DetectionEntry {
        uint256 id;
        string weaponType;
        string method;
        string location;
        uint256 timestamp;
    }

    mapping(uint256 => DetectionEntry) public detections;

    event WeaponDetected(uint256 indexed id, string weaponType, string method);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logDetection(
        string calldata weaponType,
        string calldata method,
        string calldata location
    ) external onlyOverseer {
        detectionCount++;
        detections[detectionCount] = DetectionEntry({
            id: detectionCount,
            weaponType: weaponType,
            method: method,
            location: location,
            timestamp: block.timestamp
        });
        emit WeaponDetected(detectionCount, weaponType, method);
    }

    function viewDetection(uint256 id) external view returns (DetectionEntry memory) {
        return detections[id];
    }
}
