// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title MarketAccountability
/// @notice Introduces performance-based funding logic
contract MarketAccountability {
    event FundingAllocated(address indexed department, uint256 amount, uint256 performanceScore);

    mapping(address => uint256) public performanceScores;

    function setPerformanceScore(address dept, uint256 score) public {
        performanceScores[dept] = score;
    }

    function allocateFunding(address dept, uint256 baseAmount) public {
        uint256 score = performanceScores[dept];
        uint256 adjusted = baseAmount * score / 100;
        emit FundingAllocated(dept, adjusted, score);
    }
}
