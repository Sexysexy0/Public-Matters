// SPDX-License-Identifier: FiscalSanctum
pragma solidity ^0.8.19;

contract FiscalTransparencyAuditRouter {
    struct BudgetSignal {
        string department;
        string spendingType; // e.g., "Consulting", "Infrastructure", "Emergency Relief"
        uint256 amount;
        string promiseTag; // e.g., "Housing Surge", "Trade Deal", "Bureaucracy Reduction"
        bool verified;
        string stewardNote;
    }

    mapping(string => BudgetSignal) public budgetRegistry;

    event BudgetTagged(string department, string spendingType);
    event PromiseVerified(string department);

    function tagBudget(string memory department, string memory spendingType, uint256 amount, string memory promiseTag, string memory stewardNote) public {
        budgetRegistry[department] = BudgetSignal(department, spendingType, amount, promiseTag, false, stewardNote);
        emit BudgetTagged(department, spendingType);
    }

    function verifyPromise(string memory department) public {
        require(bytes(budgetRegistry[department].spendingType).length > 0, "Budget not tagged");
        budgetRegistry[department].verified = true;
        emit PromiseVerified(department);
    }

    function getBudgetStatus(string memory department) public view returns (BudgetSignal memory) {
        return budgetRegistry[department];
    }
}
