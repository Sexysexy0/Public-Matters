// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ITrustIntegrator} from "./ITrustIntegrator.sol";

contract MicroLendingEscrow {
    ITrustIntegrator public trustIntegrator;
    address public steward;
    uint256 public maxLoanAmount;

    struct Borrower {
        uint256 maxBorrow;
        uint256 currentLoan;
        bool exists;
    }

    mapping(address => Borrower) public borrowers;

    event LoanRepaid(address indexed borrower, uint256 amount);
    event BorrowerRegistered(address indexed borrower, uint256 maxBorrow);

    modifier onlySteward() {
        require(msg.sender == steward, "Only steward");
        _;
    }

    constructor(uint256 _maxLoanAmount, address _trustIntegrator) {
        steward = msg.sender;
        maxLoanAmount = _maxLoanAmount;
        trustIntegrator = ITrustIntegrator(_trustIntegrator);
    }

    function registerBorrower(address borrower, uint256 maxBorrow) external onlySteward {
        require(!borrowers[borrower].exists, "Already registered");
        borrowers[borrower] = Borrower(maxBorrow, 0, true);
        emit BorrowerRegistered(borrower, maxBorrow);
    }

    function repayLoan(address borrower, uint256 amount) external onlySteward {
        require(borrowers[borrower].exists, "Not registered");
        require(amount > 0, "Amount must be > 0");
        
        trustIntegrator.logPositiveAction(
            string(abi.encodePacked("Loan repaid: ", borrower)),
            15
        );
        emit LoanRepaid(borrower, amount);
    }

    function setTrustIntegrator(address _new) external onlySteward {
        trustIntegrator = ITrustIntegrator(_new);
    }
}
