// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// NewsBalanceScoreEngine: compute weighted balance score for media coverage
contract NewsBalanceScoreEngine {
    address public steward;

    // weights for each dimension
    uint256 public goodBadWeight = 40;
    uint256 public allyEnemyWeight = 30;
    uint256 public contextWeight = 30;

    event ScoreComputed(string outlet, uint256 score, string classification);

    constructor() {
        steward = msg.sender;
    }

    function updateWeights(uint256 g, uint256 a, uint256 c) external {
        require(msg.sender == steward, "Only steward");
        require(g + a + c == 100, "Weights must sum to 100");
        goodBadWeight = g;
        allyEnemyWeight = a;
        contextWeight = c;
    }

    // compute balance score
    function computeScore(
        string calldata outlet,
        uint256 goodBadRatio,   // 0–100
        uint256 allyEnemyRatio, // 0–100
        uint256 contextDepth    // 0–100
    ) external {
        require(msg.sender == steward, "Only steward");
        uint256 score = (
            goodBadRatio * goodBadWeight +
            allyEnemyRatio * allyEnemyWeight +
            contextDepth * contextWeight
        ) / 100;

        string memory classification;
        if (score >= 70) {
            classification = "Reliable";
        } else if (score >= 40) {
            classification = "Unbalanced";
        } else {
            classification = "Critical Bias";
        }

        emit ScoreComputed(outlet, score, classification);
    }
}
