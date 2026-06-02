// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title BladeContinuity
/// @notice Safeguard contract for development continuity of Blade game
/// @dev Encodes milestones, transparency logs, and community trust equity

contract BladeContinuity {
    address public guardian;
    uint256 public milestoneCount;

    struct Milestone {
        uint256 id;
        string phase;      // e.g., "Pre-production", "Alpha Build", "Gameplay Reveal"
        string description;
        uint256 timestamp;
        bool completed;
    }

    mapping(uint256 => Milestone) public milestones;

    event MilestoneLogged(uint256 id, string phase, string description, uint256 timestamp);
    event MilestoneCompleted(uint256 id, uint256 timestamp);
    event TransparencyUpdate(string message, uint256 timestamp);
    event CommunityTrustAudit(string report, uint256 timestamp);

    modifier onlyGuardian() {
        require(msg.sender == guardian, "Not authorized");
        _;
    }

    constructor(address _guardian) {
        guardian = _guardian;
        milestoneCount = 0;
    }

    /// @notice Log a new development milestone
    function logMilestone(string calldata phase, string calldata description) external onlyGuardian {
        milestoneCount++;
        milestones[milestoneCount] = Milestone(milestoneCount, phase, description, block.timestamp, false);
        emit MilestoneLogged(milestoneCount, phase, description, block.timestamp);
    }

    /// @notice Mark a milestone as completed
    function completeMilestone(uint256 id) external onlyGuardian {
        require(!milestones[id].completed, "Already completed");
        milestones[id].completed = true;
        emit MilestoneCompleted(id, block.timestamp);
    }

    /// @notice Log a transparency update for the community
    function logTransparency(string calldata message) external onlyGuardian {
        emit TransparencyUpdate(message, block.timestamp);
    }

    /// @notice Log a community trust audit report
    function logTrustAudit(string calldata report) external onlyGuardian {
        emit CommunityTrustAudit(report, block.timestamp);
    }

    /// @notice Check if a milestone is completed
    function milestoneCompleted(uint256 id) external view returns (bool) {
        return milestones[id].completed;
    }
}
