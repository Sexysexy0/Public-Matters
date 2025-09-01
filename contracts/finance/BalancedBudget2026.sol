// SPDX-License-Identifier: MPL-1.0
pragma solidity ^0.8.21;

/// @title BalancedBudget2026
/// @notice Simulates a barangay-blessed, emotionally tagged balanced budget for FY 2026
contract BalancedBudget2026 {
    event BudgetLogged(uint256 revenues, uint256 disbursements, int256 surplusDeficit, bool balanced, uint256 timestamp);
    event EmotionalAPR(uint256 joyIndex, uint256 griefIndex, uint256 trustIndex, uint256 timestamp);

    uint256 public revenues;
    uint256 public disbursements;
    int256 public surplusDeficit;
    bool public isBalanced;

    function setBudget(uint256 _revenues, uint256 _disbursements) external {
        revenues = _revenues;
        disbursements = _disbursements;
        surplusDeficit = int256(_revenues) - int256(_disbursements);
        isBalanced = (surplusDeficit == 0);
        emit BudgetLogged(_revenues, _disbursements, surplusDeficit, isBalanced, block.timestamp);
    }

    function logEmotionalAPR(uint256 joyIndex, uint256 griefIndex, uint256 trustIndex) external {
        emit EmotionalAPR(joyIndex, griefIndex, trustIndex, block.timestamp);
    }

    function getStatus() external view returns (string memory status) {
        if (isBalanced) return unicode"✅ Budget is balanced";
        if (surplusDeficit > 0) return unocode"📈 Surplus detected";
        return "📉 Deficit detected";
    }
}
