// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * Universal Dividend Covenant
 * Purpose: Distribute dividends to all registered citizens
 * Effect: Ensures systemic prosperity is shared beyond wages
 * Safeguard: Triggered by Public Benefit Oracle, cannot be skipped
 */

contract UniversalDividendCovenant {
    address public governanceBody;
    uint256 public dividendPool;
    uint256 public dividendPerCitizen;

    mapping(address => bool) public registeredCitizens;
    mapping(address => uint256) public dividendsClaimed;

    event CitizenRegistered(address indexed citizen);
    event DividendDistributed(uint256 totalPool, uint256 perCitizen);
    event DividendClaimed(address indexed citizen, uint256 amount);

    modifier onlyGovernance() {
        require(msg.sender == governanceBody, "Not authorized");
        _;
    }

    constructor() {
        governanceBody = msg.sender;
    }

    function registerCitizen(address citizen) external onlyGovernance {
        registeredCitizens[citizen] = true;
        emit CitizenRegistered(citizen);
    }

    function fundDividendPool(uint256 amount) external onlyGovernance {
        dividendPool += amount;
    }

    function distributeDividends(address[] calldata citizens) external onlyGovernance {
        require(dividendPool > 0, "No funds in pool");
        dividendPerCitizen = dividendPool / citizens.length;

        for (uint256 i = 0; i < citizens.length; i++) {
            if (registeredCitizens[citizens[i]]) {
                dividendsClaimed[citizens[i]] += dividendPerCitizen;
                emit DividendClaimed(citizens[i], dividendPerCitizen);
            }
        }

        emit DividendDistributed(dividendPool, dividendPerCitizen);
        dividendPool = 0; // reset pool after distribution
    }

    function getDividend(address citizen) external view returns (uint256) {
        return dividendsClaimed[citizen];
    }
}
