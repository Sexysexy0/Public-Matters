// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Covenant Vision
/// @notice Anchor contract encoding vision and value hierarchy
contract CovenantVision {
    address public guardian;
    uint256 public visionCount;

    struct Vision {
        uint256 id;
        string title;
        string narrative;
        string domain;
        bool active;
    }

    mapping(uint256 => Vision) public visions;

    event GuardianChanged(address indexed oldGuardian, address indexed newGuardian);
    event VisionDeclared(uint256 indexed id, string title, string domain);
    event VisionUpdated(uint256 indexed id, string title, string narrative);
    event VisionStatusChanged(uint256 indexed id, bool active);

    constructor() {
        guardian = msg.sender;
        visionCount = 0;
    }

    modifier onlyGuardian() {
        require(msg.sender == guardian, "Not authorized");
        _;
    }

    /// @notice Palitan ang guardian
    function changeGuardian(address newGuardian) external onlyGuardian {
        require(newGuardian != address(0), "Invalid guardian");
        emit GuardianChanged(guardian, newGuardian);
        guardian = newGuardian;
    }

    /// @notice Mag‑declare ng bagong vision
    function declareVision(string calldata title, string calldata narrative, string calldata domain) external onlyGuardian {
        visionCount++;
        visions[visionCount] = Vision(visionCount, title, narrative, domain, true);
        emit VisionDeclared(visionCount, title, domain);
    }

    /// @notice Mag‑update ng existing vision
    function updateVision(uint256 id, string calldata title, string calldata narrative) external onlyGuardian {
        Vision storage v = visions[id];
        v.title = title;
        v.narrative = narrative;
        emit VisionUpdated(id, title, narrative);
    }

    /// @notice Baguhin ang status ng vision (active/inactive)
    function setVisionStatus(uint256 id, bool active) external onlyGuardian {
        visions[id].active = active;
        emit VisionStatusChanged(id, active);
    }

    /// @notice Tingnan ang vision details
    function viewVision(uint256 id) external view returns (Vision memory) {
        return visions[id];
    }
}
