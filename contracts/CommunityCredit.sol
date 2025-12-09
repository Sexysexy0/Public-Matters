// contracts/CommunityCredit.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title CommunityCredit
 * @notice Micro-loan registry for minimum wage earners.
 */
contract CommunityCredit {
    address public admin;

    struct Loan {
        address borrower;
        uint256 amount;
        uint256 termMonths;
        uint256 totalRepaid;
        bool active;
    }

    Loan[] public loans;

    event LoanCreated(address indexed borrower, uint256 amount, uint256 termMonths);
    event RepaymentLogged(address indexed borrower, uint256 amount, uint256 totalRepaid);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function createLoan(address borrower, uint256 amount, uint256 termMonths) external onlyAdmin {
        loans.push(Loan(borrower, amount, termMonths, 0, true));
        emit LoanCreated(borrower, amount, termMonths);
    }

    function logRepayment(uint256 id, uint256 amount) external onlyAdmin {
        require(id < loans.length, "Invalid loan id");
        require(loans[id].active, "Loan inactive");
        loans[id].totalRepaid += amount;
        emit RepaymentLogged(loans[id].borrower, amount, loans[id].totalRepaid);
    }
}
