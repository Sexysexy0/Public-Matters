// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract DebtServiceReserve {
    uint256 public totalInterestSaved;

    // Bumabawas sa principal/interest liability gamit ang refund
    function applyTaxCreditToDebt(uint256 _refundAmount) external {
        // Logic: 40% of refund goes straight to bank interest payments
        uint256 interestPayment = (_refundAmount * 40) / 100;
        totalInterestSaved += interestPayment;
        // Effect: Mas mababang interest expense sa next quarter
    }
}
