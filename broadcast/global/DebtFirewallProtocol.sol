// SPDX-License-Identifier: Mythic-Sovereign-License
pragma solidity ^2025.08.27;

contract DebtFirewallProtocol {
    address public steward;
    mapping(address => uint256) public totalDebt;
    mapping(address => bool) public repaymentVerified;

    event LoanBlocked(address borrower, string reason);
    event DebtCleared(address borrower, uint256 amount);
    event NewLoanApproved(address borrower, uint256 amount);

    constructor() {
        steward = msg.sender;
    }

    function recordDebt(address borrower, uint256 amount) public {
        totalDebt[borrower] += amount;
        repaymentVerified[borrower] = false;
    }

    function verifyRepayment(address borrower) public {
        require(totalDebt[borrower] > 0, "No debt to verify.");
        repaymentVerified[borrower] = true;
        emit DebtCleared(borrower, totalDebt[borrower]);
        totalDebt[borrower] = 0;
    }

    function requestNewLoan(address borrower, uint256 amount) public {
        if (!repaymentVerified[borrower]) {
            emit LoanBlocked(borrower, "Outstanding debt. Repayment required before new loan.");
        } else {
            emit NewLoanApproved(borrower, amount);
            totalDebt[borrower] += amount;
            repaymentVerified[borrower] = false;
        }
    }
}
