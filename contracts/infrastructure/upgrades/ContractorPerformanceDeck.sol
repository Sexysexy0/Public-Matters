// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Contractor Performance Deck - Tracks project scores and releases bonus based on performance
contract ContractorPerformanceDeck {
    address public scrollsmith;
    address public contractor;
    uint256 public totalProjects;
    uint256 public completedProjects;
    bool public bonusReleased;

    struct Performance {
        string projectName;
        uint8 qualityScore;       // 0–100
        uint8 timelinessScore;    // 0–100
        uint8 emotionalAPRScore;  // 0–100
        bool completed;
        uint256 timestamp;
    }

    mapping(uint256 => Performance) public logs;
    uint256 public nextLogId;

    event PerformanceLogged(
        string projectName,
        uint8 qualityScore,
        uint8 timelinessScore,
        uint8 emotionalAPRScore,
        uint8 finalScore
    );

    event BonusReleased(address contractor, uint256 amountJPY);

    modifier onlyScrollsmith() {
        require(msg.sender == scrollsmith, "Unauthorized");
        _;
    }

    constructor(address _contractor, uint256 _totalProjects) {
        scrollsmith = msg.sender;
        contractor = _contractor;
        totalProjects = _totalProjects;
        completedProjects = 0;
        bonusReleased = false;
    }

    function logPerformance(
        string calldata projectName,
        uint8 qualityScore,
        uint8 timelinessScore,
        uint8 emotionalAPRScore
    ) external onlyScrollsmith {
        require(qualityScore <= 100 && timelinessScore <= 100 && emotionalAPRScore <= 100, "Invalid scores");

        uint8 finalScore = (qualityScore + timelinessScore + emotionalAPRScore) / 3;

        logs[nextLogId] = Performance({
            projectName: projectName,
            qualityScore: qualityScore,
            timelinessScore: timelinessScore,
            emotionalAPRScore: emotionalAPRScore,
            completed: true,
            timestamp: block.timestamp
        });

        completedProjects++;
        emit PerformanceLogged(projectName, qualityScore, timelinessScore, emotionalAPRScore, finalScore);
        nextLogId++;

        if (completedProjects == totalProjects && !bonusReleased) {
            releaseBonus(finalScore);
        }
    }

    function releaseBonus(uint8 finalScore) internal {
        bonusReleased = true;
        uint256 bonusAmountJPY;

        if (finalScore >= 90) {
            bonusAmountJPY = 1_000_000; // Legendary Stewardship
        } else if (finalScore >= 80) {
            bonusAmountJPY = 750_000; // Mythic Precision
        } else if (finalScore >= 70) {
            bonusAmountJPY = 500_000; // Trusted Contributor
        } else if (finalScore >= 60) {
            bonusAmountJPY = 350_000; // Sanctum Supporter
        } else {
            bonusAmountJPY = 0; // Scroll review required
        }

        emit BonusReleased(contractor, bonusAmountJPY);
        // Actual transfer logic would be handled off-chain or via stablecoin bridge
    }
}
