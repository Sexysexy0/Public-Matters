// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * Profit Sharing Covenant
 * Purpose: Distribute a percentage of corporate/system profits to workers
 * Effect: Ensures fair sharing of prosperity beyond wages
 * Safeguard: Workers always receive base wage + share, never less
 */

contract ProfitSharingCovenant {
    address public governanceBody;
    uint256 public baseWage;
    uint256 public profitSharePercent = 5; // 5% of profits shared

    mapping(address => uint256) public wages;
    mapping(address => uint256) public profitShares;

    event ProfitShared(address indexed worker, uint256 amount);

    modifier onlyGovernance() {
        require(msg.sender == governanceBody, "Not authorized");
        _;
    }

    constructor(uint256 _baseWage) {
        governanceBody = msg.sender;
        baseWage = _baseWage;
    }

    function registerWorker(address worker) external onlyGovernance {
        wages[worker] = baseWage;
    }

    function distributeProfits(uint256 totalProfits, address[] calldata workers) external onlyGovernance {
        uint256 sharePerWorker = (totalProfits * profitSharePercent) / (100 * workers.length);
        for (uint256 i = 0; i < workers.length; i++) {
            profitShares[workers[i]] += sharePerWorker;
            emit ProfitShared(workers[i], sharePerWorker);
        }
    }

    function getTotalCompensation(address worker) external view returns (uint256) {
        return wages[worker] + profitShares[worker];
    }
}
