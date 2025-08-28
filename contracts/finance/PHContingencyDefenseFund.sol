// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title PHContingencyDefenseFund
/// @notice Allocates emergency funds for repatriation, naval defense, and rescue operations
contract PHContingencyDefenseFund {
    address public steward;
    uint256 public totalFund;
    mapping(string => uint256) public allocations;

    event FundAllocated(string sector, uint256 amount, uint256 timestamp);
    event EmergencyWithdrawal(string purpose, uint256 amount, uint256 timestamp);

    constructor() {
        steward = msg.sender;
        totalFund = 0;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    function deposit() external payable {
        totalFund += msg.value;
    }

    function allocate(string memory sector, uint256 amount) external onlySteward {
        require(amount <= totalFund, "Insufficient fund");
        allocations[sector] += amount;
        totalFund -= amount;
        emit FundAllocated(sector, amount, block.timestamp);
    }

    function emergencyWithdraw(string memory purpose, uint256 amount) external onlySteward {
        require(amount <= totalFund, "Insufficient fund");
        totalFund -= amount;
        emit EmergencyWithdrawal(purpose, amount, block.timestamp);
    }

    function getAllocation(string memory sector) public view returns (uint256) {
        return allocations[sector];
    }

    function getTotalFund() public view returns (uint256) {
        return totalFund;
    }
}
