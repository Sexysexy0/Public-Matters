// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// CapacityScoreEngine: compute weighted readiness score for fighter capacity evaluation
contract CapacityScoreEngine {
    address public steward;

    // weights for each dimension
    uint256 public fleetWeight = 35;
    uint256 public upgradeWeight = 25;
    uint256 public costWeight = 25;
    uint256 public droneWeight = 15;

    event ScoreComputed(string model, uint256 score, string classification);

    constructor() {
        steward = msg.sender;
    }

    function updateWeights(uint256 f, uint256 u, uint256 c, uint256 d) external {
        require(msg.sender == steward, "Only steward");
        require(f + u + c + d == 100, "Weights must sum to 100");
        fleetWeight = f;
        upgradeWeight = u;
        costWeight = c;
        droneWeight = d;
    }

    // compute readiness score
    function computeScore(
        string calldata model,
        uint256 fleetScore,   // 0–100
        uint256 upgradeScore, // 0–100
        uint256 costScore,    // 0–100
        uint256 droneScore    // 0–100
    ) external {
        require(msg.sender == steward, "Only steward");
        uint256 score = (
            fleetScore * fleetWeight +
            upgradeScore * upgradeWeight +
            costScore * costWeight +
            droneScore * droneWeight
        ) / 100;

        string memory classification;
        if (score >= 70) {
            classification = "Combat-Ready";
        } else if (score >= 40) {
            classification = "Bridge-Ready";
        } else {
            classification = "Critical Gap";
        }

        emit ScoreComputed(model, score, classification);
    }
}
