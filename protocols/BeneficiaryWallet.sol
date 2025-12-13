// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// BeneficiaryWallet: record balances for each person
contract BeneficiaryWallet {
    mapping(address => uint256) public balances;
    mapping(address => bool) public stewards;

    event BalanceUpdated(address indexed beneficiary, uint256 newBalance);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function deposit(address beneficiary, uint256 amount) external {
        require(stewards[msg.sender], "Only steward");
        balances[beneficiary] += amount;
        emit BalanceUpdated(beneficiary, balances[beneficiary]);
    }

    function spend(address beneficiary, uint256 amount) external {
        require(stewards[msg.sender], "Only steward");
        require(balances[beneficiary] >= amount, "Insufficient balance");
        balances[beneficiary] -= amount;
        emit BalanceUpdated(beneficiary, balances[beneficiary]);
    }
}
