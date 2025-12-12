// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// SpeedLedger: record fast-track loan approvals for premium members
contract SpeedLedger {
    struct Loan {
        uint256 id;
        address member;
        uint256 principal;
        uint256 tenorMonths;
        bool released;
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Loan) public loans;
    mapping(address => bool) public stewards;

    event LoanRequested(uint256 indexed id, address member, uint256 principal);
    event LoanReleased(uint256 indexed id);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function requestLoan(address member, uint256 principal, uint256 tenorMonths) external {
        require(stewards[msg.sender], "Only steward");
        loans[nextId] = Loan(nextId, member, principal, tenorMonths, false, block.timestamp);
        emit LoanRequested(nextId, member, principal);
        nextId++;
    }

    function release(uint256 id) external {
        require(stewards[msg.sender], "Only steward");
        loans[id].released = true;
        emit LoanReleased(id);
    }
}
