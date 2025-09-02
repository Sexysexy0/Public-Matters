// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract BarangayBlessedMicroloan {
    struct Microloan {
        address borrower;
        uint256 amount;
        uint256 emotionalAPR;
        bool repaid;
    }

    mapping(uint256 => Microloan) public loans;
    uint256 public loanCounter;
    event MicroloanIssued(address indexed borrower, uint256 amount, uint256 emotionalAPR);
    event MicroloanRepaid(address indexed borrower, uint256 loanId);

    function issueLoan(address borrower, uint256 amount, uint256 emotionalAPR) public {
        loans[loanCounter] = Microloan(borrower, amount, emotionalAPR, false);
        emit MicroloanIssued(borrower, amount, emotionalAPR);
        loanCounter++;
    }

    function repayLoan(uint256 loanId) public {
        require(msg.sender == loans[loanId].borrower, "Not borrower");
        loans[loanId].repaid = true;
        emit MicroloanRepaid(msg.sender, loanId);
    }
}
