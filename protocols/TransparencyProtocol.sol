// TransparencyProtocol.sol
pragma solidity ^0.8.0;

contract TransparencyProtocol {
    struct Expense {
        uint256 id;
        string agency;   // e.g. "TESDA"
        string purpose;  // e.g. "Training Program"
        uint256 amount;
        uint256 timestamp;
    }

    uint256 public expenseCount;
    mapping(uint256 => Expense) public expenses;

    event ExpenseLogged(uint256 id, string agency, string purpose, uint256 amount, uint256 timestamp);
    event TransparencyDeclared(string message);

    function logExpense(string memory agency, string memory purpose, uint256 amount) public {
        expenseCount++;
        expenses[expenseCount] = Expense(expenseCount, agency, purpose, amount, block.timestamp);
        emit ExpenseLogged(expenseCount, agency, purpose, amount, block.timestamp);
    }

    function declareTransparency() public {
        emit TransparencyDeclared("Transparency Protocol: validator-grade safeguards encoded into communal dignity.");
    }
}
