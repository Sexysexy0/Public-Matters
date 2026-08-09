import "./ITrustIntegrator.sol";
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MicroLendingEscrow {
    address public immutable steward;
    ITrustIntegrator public trustIntegrator;
    uint256 public baseInterestRate;
    uint256 public totalLiquidity;

    struct Loan {
        address borrower;
        uint256 principal;
        uint256 dueAmount;
        uint256 dueDate;
        bool isActive;
        bool isPaid;
    }

    mapping(address => Loan) public activeLoans;
    mapping(address => uint256) public creditScore;

    event LiquidityDeposited(address indexed from, uint256 amount);
    event LoanIssued(address indexed borrower, uint256 amount, uint256 dueAmount, uint256 dueDate);
    event LoanRepaid(address indexed borrower, uint256 amount);
    event LiquidityWithdrawn(address indexed to, uint256 amount);
    event TrustIntegratorUpdated(address newIntegrator);

    modifier onlySteward() {
        require(msg.sender == steward, "Only the steward");
        _;
    }

    constructor(uint256 _baseInterestRate, address _trustIntegrator) {
        steward = msg.sender;
        baseInterestRate = _baseInterestRate;
        trustIntegrator = ITrustIntegrator(_trustIntegrator);
    }

    function depositLiquidity() external payable {
        require(msg.value > 0, "Must deposit some funds");
        totalLiquidity += msg.value;
        emit LiquidityDeposited(msg.sender, msg.value);
    }

    receive() external payable {
        totalLiquidity += msg.value;
        emit LiquidityDeposited(msg.sender, msg.value);
    }

    function requestLoan(uint256 _amount, uint256 _durationDays) external {
        require(_amount > 0, "Loan amount must be > 0");
        require(creditScore[msg.sender] >= 10, "Credit score too low");
        require(!activeLoans[msg.sender].isActive, "Existing loan active");

        uint256 interest = (_amount * baseInterestRate * _durationDays) / (365 * 10000);
        uint256 dueAmount = _amount + interest;
        uint256 dueDate = block.timestamp + (_durationDays * 1 days);

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

    function repayLoan() external payable {
        Loan storage loan = activeLoans[msg.sender];
        require(loan.isActive, "No active loan");
        require(msg.value >= loan.dueAmount, "Insufficient repayment amount");

        uint256 refund = msg.value - loan.dueAmount;
        loan.isActive = false;
        loan.isPaid = true;
        totalLiquidity += loan.dueAmount;

        creditScore[msg.sender] += 5;

        trustIntegrator.logPositiveAction(15);

        emit LoanRepaid(msg.sender, loan.dueAmount);

        if (refund > 0) {
            payable(msg.sender).transfer(refund);
        }
    }

    function registerBorrower(address _borrower, uint256 _initialScore) external onlySteward {
        require(creditScore[_borrower] == 0, "Already registered");
        creditScore[_borrower] = _initialScore;
    }

    function withdrawLiquidity(uint256 _amount) external onlySteward {
        require(_amount <= totalLiquidity, "Insufficient balance");
        totalLiquidity -= _amount;
        payable(steward).transfer(_amount);
        emit LiquidityWithdrawn(steward, _amount);
    }

    function setTrustIntegrator(address _newIntegrator) external onlySteward {
        trustIntegrator = ITrustIntegrator(_newIntegrator);
        emit TrustIntegratorUpdated(_newIntegrator);
    }
}
