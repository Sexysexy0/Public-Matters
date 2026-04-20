// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract InfrastructureReinvest {
    uint256 public refineryMaintenanceBudget;

    // Allocation para sa upgrades at bagong equipment
    function allocateForRefinery(uint256 _refundAmount) external {
        // Logic: 35% of refund is locked for Capex (Capital Expenditure)
        uint256 capex = (_refundAmount * 35) / 100;
        refineryMaintenanceBudget += capex;
    }
}
