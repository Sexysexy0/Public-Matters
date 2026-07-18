// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * Public Benefit Oracle + Risk Context Review Integration
 * Purpose: Link systemic indicators to automatic risk evaluations
 * Effect: Ensures policies/contracts are reviewed with real-world context
 * Safeguard: Governance-controlled approval, transparent risk logging
 */

contract PublicBenefitRiskIntegration {
    address public governanceBody;

    enum RiskLevel { Low, Medium, High }

    struct Review {
        string policyName;
        RiskLevel riskLevel;
        bool approved;
    }

    mapping(uint256 => Review) public reviews;
    uint256 public reviewCount;

    uint256 public gdpGrowth;
    uint256 public inflationRate;
    uint256 public corporateProfitGrowth;
    uint256 public publicWelfareIndex;

    event IndicatorsUpdated(uint256 gdpGrowth, uint256 inflationRate, uint256 corporateProfitGrowth, uint256 publicWelfareIndex);
    event PolicySubmitted(uint256 indexed id, string policyName);
    event PolicyReviewed(uint256 indexed id, RiskLevel riskLevel, bool approved);

    modifier onlyGovernance() {
        require(msg.sender == governanceBody, "Not authorized");
        _;
    }

    constructor() {
        governanceBody = msg.sender;
    }

    // Update systemic indicators
    function updateIndicators(
        uint256 _gdpGrowth,
        uint256 _inflationRate,
        uint256 _corporateProfitGrowth,
        uint256 _publicWelfareIndex
    ) external onlyGovernance {
        gdpGrowth = _gdpGrowth;
        inflationRate = _inflationRate;
        corporateProfitGrowth = _corporateProfitGrowth;
        publicWelfareIndex = _publicWelfareIndex;

        emit IndicatorsUpdated(gdpGrowth, inflationRate, corporateProfitGrowth, publicWelfareIndex);
    }

    // Submit new policy for review
    function submitPolicy(string calldata policyName) external onlyGovernance {
        reviewCount++;
        reviews[reviewCount] = Review(policyName, RiskLevel.Low, false);
        emit PolicySubmitted(reviewCount, policyName);
    }

    // Automatic risk evaluation based on indicators
    function autoEvaluate(uint256 id) public onlyGovernance {
        require(id <= reviewCount, "Invalid policy ID");
        RiskLevel level = RiskLevel.Low;

        if (inflationRate > 5 || publicWelfareIndex < 50) {
            level = RiskLevel.High;
        } else if (gdpGrowth < 2 || corporateProfitGrowth < 5) {
            level = RiskLevel.Medium;
        }

        reviews[id].riskLevel = level;
        emit PolicyReviewed(id, level, reviews[id].approved);
    }

    // Governance final approval
    function approvePolicy(uint256 id, bool approved) external onlyGovernance {
        require(id <= reviewCount, "Invalid policy ID");
        reviews[id].approved = approved;
        emit PolicyReviewed(id, reviews[id].riskLevel, approved);
    }

    function isDeployable(uint256 id) external view returns (bool) {
        Review memory r = reviews[id];
        return r.approved && r.riskLevel != RiskLevel.High;
    }
}
