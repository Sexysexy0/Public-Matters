// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * Wage Increase Covenant
 * Purpose: Automatically adjust wages based on systemic indicators
 * Effect: Ensures fair wage growth tied to GDP, inflation, and corporate profits
 * Safeguard: Wages never decrease, only increase or stay at base floor
 */

contract WageIncreaseCovenant {
    address public governanceBody;
    uint256 public baseWage;
    uint256 public gdpGrowthThreshold = 3;   // 3%
    uint256 public inflationThreshold = 5;   // 5%
    uint256 public profitThreshold = 10;     // 10% growth

    mapping(address => uint256) public wages;

    event WageAdjusted(address indexed worker, uint256 newWage);

    modifier onlyGovernance() {
        require(msg.sender == governanceBody, "Not authorized");
        _;
    }

    constructor(uint256 _baseWage) {
        governanceBody = msg.sender;
        baseWage = _baseWage;
    }

    function setEconomicIndicators(
        uint256 gdpGrowth,
        uint256 inflation,
        uint256 corporateProfitGrowth
    ) external onlyGovernance {
        if (
            gdpGrowth > gdpGrowthThreshold ||
            inflation > inflationThreshold ||
            corporateProfitGrowth > profitThreshold
        ) {
            baseWage += (baseWage * 10) / 100; // automatic 10% increase
        }
    }

    function registerWorker(address worker) external onlyGovernance {
        wages[worker] = baseWage;
        emit WageAdjusted(worker, baseWage);
    }

    function getWage(address worker) external view returns (uint256) {
        return wages[worker];
    }
}
