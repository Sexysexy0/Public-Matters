// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// LoanZeroInterestRegistry: record loans charged at 0% on member-owned contributions
contract LoanZeroInterestRegistry {
    struct Loan {
        uint256 id;
        address member;
        uint256 principal;    // pesos value
        uint256 tenorMonths;  // repayment tenor
        bool approved;
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Loan) public loans;
    mapping(address => bool) public stewards;

    event LoanRequested(uint256 indexed id, address member, uint256 principal, uint256 tenorMonths);
    event LoanApproved(uint256 indexed id);
    event LoanRepaid(uint256 indexed id);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function requestLoan(address member, uint256 principal, uint256 tenorMonths) external {
        require(stewards[msg.sender], "Only steward");
        loans[nextId] = Loan(nextId, member, principal, tenorMonths, false, block.timestamp);
        emit LoanRequested(nextId, member, principal, tenorMonths);
        nextId++;
    }

    function approve(uint256 id) external {
        require(stewards[msg.sender], "Only steward");
        loans[id].approved = true;
        emit LoanApproved(id);
    }

    function markRepaid(uint256 id) external {
        require(stewards[msg.sender], "Only steward");
        emit LoanRepaid(id);
    }
}
