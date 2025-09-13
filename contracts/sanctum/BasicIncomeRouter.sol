// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BasicIncomeRouter {
    enum BeneficiaryType { Youth, PregnantWomen, Elders, PWD }
    enum IncomeTier { Starter, Sustaining, CrisisShield }

    struct IncomeBlessing {
        uint256 id;
        BeneficiaryType beneficiaryType;
        IncomeTier incomeTier;
        uint256 monthlyPHP;
        string clauseReference;
        uint256 timestamp;
    }

    mapping(uint256 => IncomeBlessing) public incomeRegistry;
    uint256 public incomeCount;

    event BlessingLogged(uint256 id, BeneficiaryType beneficiaryType, IncomeTier incomeTier);
    event IncomeUpdated(uint256 id, uint256 newMonthlyPHP);

    function logIncome(
        BeneficiaryType beneficiaryType,
        IncomeTier incomeTier,
        uint256 monthlyPHP,
        string memory clauseReference,
        uint256 timestamp
    ) public {
        incomeRegistry[incomeCount] = IncomeBlessing(
            incomeCount,
            beneficiaryType,
            incomeTier,
            monthlyPHP,
            clauseReference,
            timestamp
        );
        emit BlessingLogged(incomeCount, beneficiaryType, incomeTier);
        incomeCount++;
    }

    function updateIncome(uint256 id, uint256 newMonthlyPHP) public {
        require(id < incomeCount, "Invalid income ID");
        incomeRegistry[id].monthlyPHP = newMonthlyPHP;
        emit IncomeUpdated(id, newMonthlyPHP);
    }

    function getIncomeBlessing(uint256 id) public view returns (IncomeBlessing memory) {
        return incomeRegistry[id];
    }
}
