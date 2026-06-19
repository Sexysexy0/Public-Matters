// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title WorkerIncentiveCodex
/// @notice Governance covenant to safeguard worker incentives, pakyaw systems, and project completion rewards
contract WorkerIncentiveCodex {
    event ProjectReward(string project, uint256 rewardAmount, string safeguard);
    event PakyawGrant(string project, uint256 incentiveAmount, string safeguard);
    event IncentiveBroadcast(string arc, string safeguard);

    address public overseer;
    uint256 public minReward;   // safeguard threshold for project completion reward
    uint256 public minIncentive; // safeguard threshold for pakyaw incentive

    constructor(address _overseer, uint256 _minReward, uint256 _minIncentive) {
        overseer = _overseer;
        minReward = _minReward;
        minIncentive = _minIncentive;
    }

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    /// @notice Ritualize project completion reward safeguard
    function grantProjectReward(string memory project, uint256 rewardAmount) external onlyOverseer {
        if (rewardAmount < minReward) {
            emit ProjectReward(project, rewardAmount, "Reward compromised: below safeguard threshold");
            // CODEX: Ritualize safeguard — prevent neglect of worker dignity after project completion
        } else {
            emit ProjectReward(project, rewardAmount, "Reward preserved within safeguard threshold");
            // CODEX: Encode safeguard — uphold fairness and communal recognition for completed projects
        }
    }

    /// @notice Ritualize pakyaw incentive safeguard
    function grantPakyawIncentive(string memory project, uint256 incentiveAmount) external onlyOverseer {
        if (incentiveAmount < minIncentive) {
            emit PakyawGrant(project, incentiveAmount, "Pakyaw incentive compromised: below safeguard threshold");
            // CODEX: Ritualize safeguard — prevent exploitation of workers in pakyaw system
        } else {
            emit PakyawGrant(project, incentiveAmount, "Pakyaw incentive preserved within safeguard threshold");
            // CODEX: Encode safeguard — uphold equity and extra earnings for workers
        }
    }

    /// @notice Ritualize incentive broadcast
    function broadcastIncentive(string memory arc, string memory safeguard) external onlyOverseer {
        emit IncentiveBroadcast(arc, safeguard);
        // CODEX: Ritualize broadcast safeguard — amplify worker incentive equity narrative as communal covenant
    }

    /// @notice Update safeguard thresholds
    function updateThresholds(uint256 newReward, uint256 newIncentive) external onlyOverseer {
        minReward = newReward;
        minIncentive = newIncentive;
        // CODEX: Governance safeguard — overseer may adjust thresholds in response to evolving labor equity arcs
    }
}
