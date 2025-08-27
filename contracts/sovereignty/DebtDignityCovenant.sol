// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.27;

contract DebtDignityCovenant {
    address public steward;
    mapping(address => uint256) public debtLedger;
    mapping(address => bool) public breachFlag;

    event DebtLogged(address debtor, uint256 amount);
    event BreachDetected(address debtor, string reason);
    event SovereignRepayment(address debtor, uint256 amount);
    event DamayClauseActivated(address beneficiary, uint256 reliefAmount);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward.");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function logDebt(address debtor, uint256 amount) external onlySteward {
        debtLedger[debtor] += amount;
        emit DebtLogged(debtor, amount);
    }

    function markBreach(address debtor, string memory reason) external onlySteward {
        breachFlag[debtor] = true;
        emit BreachDetected(debtor, reason);
    }

    function repayDebt(address debtor) external payable {
        require(!breachFlag[debtor], "Breach detected. Immediate repayment required.");
        require(msg.value >= debtLedger[debtor], "Insufficient repayment.");
        emit SovereignRepayment(debtor, msg.value);
        debtLedger[debtor] = 0;
    }

    function activateDamayClause(address beneficiary, uint256 reliefAmount) external onlySteward {
        payable(beneficiary).transfer(reliefAmount);
        emit DamayClauseActivated(beneficiary, reliefAmount);
    }

    function getDebt(address debtor) external view returns (uint256) {
        return debtLedger[debtor];
    }

    function isInBreach(address debtor) external view returns (bool) {
        return breachFlag[debtor];
    }
}
