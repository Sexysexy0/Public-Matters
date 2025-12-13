// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// WithdrawalMirror: record withdrawals and usage
contract WithdrawalMirror {
    struct Withdrawal {
        uint256 id;
        address beneficiary;
        uint256 amount;
        string purpose; // "Hospital", "Groceries", "Bills"
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Withdrawal) public withdrawals;
    mapping(address => bool) public stewards;

    event WithdrawalLogged(uint256 indexed id, address beneficiary, uint256 amount, string purpose);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logWithdrawal(address beneficiary, uint256 amount, string calldata purpose) external {
        require(stewards[msg.sender], "Only steward");
        withdrawals[nextId] = Withdrawal(nextId, beneficiary, amount, purpose, block.timestamp);
        emit WithdrawalLogged(nextId, beneficiary, amount, purpose);
        nextId++;
    }
}
