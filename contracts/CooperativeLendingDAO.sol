// CooperativeLendingDAO.sol
pragma solidity ^0.8.0;

contract CooperativeLendingDAO {
    struct LoanRequest {
        address borrower;
        uint256 amount;
        uint256 collateralStake;
        uint256 votesReceived;
        bool funded;
    }

    mapping(uint256 => LoanRequest) public loans;
    uint256 public loanCounter;

    function requestLoan(uint256 _amount) public payable {
        require(msg.value >= _amount / 10, "Need 10% collateral");
        loanCounter++;
        loans[loanCounter] = LoanRequest(msg.sender, _amount, msg.value, 0, false);
    }

    function voteForLoan(uint256 _loanId) public {
        loans[_loanId].votesReceived++;
        if (loans[_loanId].votesReceived >= 3) { // Community consensus
            loans[_loanId].funded = true;
        }
    }
}
