// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract DebtReliefOverride {
    struct Debt {
        address debtor;
        uint256 amount;
        bool overrideTriggered;
    }

    mapping(uint256 => Debt) public debts;
    uint256 public debtCounter;
    event DebtOverrideActivated(address indexed debtor, uint256 amount);

    function logDebt(address debtor, uint256 amount) public {
        debts[debtCounter] = Debt(debtor, amount, false);
        debtCounter++;
    }

    function activateOverride(uint256 debtId) public {
        require(!debts[debtId].overrideTriggered, "Already overridden");
        debts[debtId].overrideTriggered = true;
        emit DebtOverrideActivated(debts[debtId].debtor, debts[debtId].amount);
    }
}
