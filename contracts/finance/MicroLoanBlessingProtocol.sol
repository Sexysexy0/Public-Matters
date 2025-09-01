// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract MicroLoanBlessingProtocol {
    struct Loan {
        address borrower;
        uint256 amount;
        uint256 emotionalAPR;
        uint256 repaymentDeadline;
        bool blessed;
        bool repaid;
    }

    Loan[] public loans;

    event LoanBlessed(address borrower, uint256 amount, uint256 emotionalAPR, uint256 deadline);
    event LoanRepaid(address borrower, uint256 amount);

    function blessLoan(address _borrower, uint256 _amount, uint256 _emotionalAPR, uint256 _repaymentDeadline) public {
        loans.push(Loan(_borrower, _amount, _emotionalAPR, _repaymentDeadline, true, false));
        emit LoanBlessed(_borrower, _amount, _emotionalAPR, _repaymentDeadline);
    }

    function repayLoan(uint256 _index) public {
        require(_index < loans.length, "Invalid loan index");
        Loan storage loan = loans[_index];
        require(msg.sender == loan.borrower, "Not borrower");
        require(!loan.repaid, "Already repaid");

        loan.repaid = true;
        emit LoanRepaid(loan.borrower, loan.amount);
    }

    function getAllLoans() public view returns (Loan[] memory) {
        return loans;
    }
}
