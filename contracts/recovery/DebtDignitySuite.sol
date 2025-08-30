// SPDX-License-Identifier: Restoration-License
pragma solidity ^0.8.19;

contract DebtDignitySuite {
    struct Debt {
        uint256 amount;
        bool forgiven;
        string emotionalTag;
    }

    mapping(address => Debt) public debts;
    address public steward;

    event DebtForgiven(address debtor, string emotionalTag);
    event DebtAudited(address debtor, uint256 amount, string auditNote);

    constructor() {
        steward = msg.sender;
    }

    function auditDebt(address debtor, uint256 amount, string memory auditNote) public {
        require(msg.sender == steward, "Unauthorized");
        debts[debtor] = Debt(amount, false, auditNote);
        emit DebtAudited(debtor, amount, auditNote);
    }

    function forgiveDebt(address debtor, string memory emotionalTag) public {
        require(msg.sender == steward, "Unauthorized");
        debts[debtor].forgiven = true;
        debts[debtor].emotionalTag = emotionalTag;
        emit DebtForgiven(debtor, emotionalTag);
    }
}
