// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// AllianceScoreEngine: compute weighted score for alliance evaluation
contract AllianceScoreEngine {
    address public steward;

    // weights for each dimension
    uint256 public resourceWeight = 40;
    uint256 public valuesWeight = 20;
    uint256 public conflictWeight = 25;
    uint256 public theologyWeight = 15;

    event ScoreComputed(string country, uint256 score, string classification);

    constructor() {
        steward = msg.sender;
    }

    function updateWeights(uint256 r, uint256 v, uint256 c, uint256 t) external {
        require(msg.sender == steward, "Only steward");
        require(r + v + c + t == 100, "Weights must sum to 100");
        resourceWeight = r;
        valuesWeight = v;
        conflictWeight = c;
        theologyWeight = t;
    }

    // compute alliance score
    function computeScore(
        string calldata country,
        uint256 resourceScore,   // 0–100
        uint256 valuesScore,     // 0–100
        uint256 conflictScore,   // 0–100
        uint256 theologyScore    // 0–100
    ) external {
        require(msg.sender == steward, "Only steward");
        uint256 score = (
            resourceScore * resourceWeight +
            valuesScore * valuesWeight +
            conflictScore * conflictWeight +
            theologyScore * theologyWeight
        ) / 100;

        string memory classification;
        if (score >= 70) {
            classification = "Premium Ally";
        } else if (score >= 40) {
            classification = "Neutral Ally";
        } else {
            classification = "Net Cost";
        }

        emit ScoreComputed(country, score, classification);
    }
}
