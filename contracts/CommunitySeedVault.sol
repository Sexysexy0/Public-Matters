// CommunitySeedVault.sol
pragma solidity ^0.8.0;

contract CommunitySeedVault {
    struct Loan {
        address borrower;
        uint256 amount;
        uint256 dueDate;
        bool isRepaid;
    }

    mapping(address => Loan) public activeLoans;
    uint256 public communityFund;

    function requestLoan(uint256 _amount) public {
        require(activeLoans[msg.sender].amount == 0, "Existing loan active");
        // Logic: Approved via Council of Elders
        activeLoans[msg.sender] = Loan(msg.sender, _amount, block.timestamp + 180 days, false);
    }

    function repayLoan() public payable {
        require(msg.value >= activeLoans[msg.sender].amount, "Full repayment required");
        activeLoans[msg.sender].isRepaid = true;
        communityFund += msg.value; // Fund grows back for others
    }
}
