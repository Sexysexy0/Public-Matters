// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * Inflation-Indexed Wage Covenant
 * Purpose: Adjust wages automatically based on inflation rate
 * Effect: Protects real value of wages against rising prices
 * Safeguard: Wages never decrease, only increase or stay at base floor
 */

contract InflationIndexedWageCovenant {
    address public governanceBody;
    uint256 public baseWage;
    uint256 public inflationThreshold = 5; // 5%

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

    function setInflationRate(uint256 inflation) external onlyGovernance {
        if (inflation > inflationThreshold) {
            uint256 adjustment = (baseWage * inflation) / 100;
            baseWage += adjustment;
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
