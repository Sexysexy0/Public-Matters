// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title MicroLendingEscrow
 * @dev Community lending pool against predatory loan sharks
 */
contract MicroLendingEscrow {
    address public immutable owner;
    uint256 public baseInterestRate; // Annual interest rate in basis points (e.g., 500 = 5%)
    uint256 public totalLiquidity;
    
    struct Loan {
        address borrower;
        uint256 principal;
        uint256 dueAmount; // principal + interest
        uint256 dueDate;
        bool isActive;
        bool isPaid;
    }

    mapping(address => Loan) public activeLoans;
    mapping(address => uint256) public creditScore; // Community reputation/trust score

    event LiquidityDeposited(address indexed from, uint256 amount);
    event LoanIssued(address indexed borrower, uint256 amount, uint256 dueAmount, uint256 dueDate);
    event LoanRepaid(address indexed borrower, uint256 amount);
    event LiquidityWithdrawn(address indexed to, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the architect");
        _;
    }

    constructor(uint256 _baseInterestRate) {
        owner = msg.sender;
        baseInterestRate = _baseInterestRate;
    }

    // Allow the contract to receive ETH directly (from EndowmentGovernor)
    receive() external payable {
        require(msg.value > 0, "Must deposit some funds");
        totalLiquidity += msg.value;
        emit LiquidityDeposited(msg.sender, msg.value);
    }

    // Deposit funds from the Endowment or other benefactors
    function depositLiquidity() external payable {
        require(msg.value > 0, "Must deposit some funds");
        totalLiquidity += msg.value;
        emit LiquidityDeposited(msg.sender, msg.value);
    }

    // Request a loan (borrower must be registered and have a credit score)
    function requestLoan(uint256 _amount, uint256 _durationDays) external {
        require(_amount > 0, "Loan amount must be > 0");
        require(creditScore[msg.sender] >= 10, "Credit score too low"); // Minimum score to borrow
        require(activeLoans[msg.sender].isActive == false, "Existing loan active");

        uint256 interest = (_amount * baseInterestRate * _durationDays) / (365 * 10000);
        uint256 dueAmount = _amount + interest;
        uint256 dueDate = block.timestamp + (_durationDays * 1 days);

        // Check if pool has enough liquidity
        require(totalLiquidity >= _amount, "Insufficient pool liquidity");

        totalLiquidity -= _amount;
        activeLoans[msg.sender] = Loan({
            borrower: msg.sender,
            principal: _amount,
            dueAmount: dueAmount,
            dueDate: dueDate,
            isActive: true,
            isPaid: false
        });

        payable(msg.sender).transfer(_amount);
        emit LoanIssued(msg.sender, _amount, dueAmount, dueDate);
    }

    // Repay the loan
    function repayLoan() external payable {
        Loan storage loan = activeLoans[msg.sender];
        require(loan.isActive == true, "No active loan");
        require(msg.value >= loan.dueAmount, "Insufficient repayment amount");

        // If they overpay, keep the difference as liquidity
        uint256 refund = msg.value - loan.dueAmount;
        loan.isActive = false;
        loan.isPaid = true;
        totalLiquidity += loan.dueAmount;

        // Increase credit score for good behavior
        creditScore[msg.sender] += 5;

        emit LoanRepaid(msg.sender, loan.dueAmount);

        if (refund > 0) {
            payable(msg.sender).transfer(refund);
        }
    }

    // Add a community member to the system (sets their initial credit score)
    function registerBorrower(address _borrower, uint256 _initialScore) external onlyOwner {
        require(creditScore[_borrower] == 0, "Already registered");
        creditScore[_borrower] = _initialScore;
    }

    // Withdraw excess liquidity (can be used to return funds to the Endowment)
    function withdrawLiquidity(uint256 _amount) external onlyOwner {
        require(_amount <= totalLiquidity, "Insufficient balance");
        totalLiquidity -= _amount;
        payable(owner).transfer(_amount);
        emit LiquidityWithdrawn(owner, _amount);
    }
}
