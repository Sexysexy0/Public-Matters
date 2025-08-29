// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title FullBurdenCoverageAct
 * @notice Ensures that all operational, infrastructure, environmental,
 *         and compliance expenses of a company are fully borne by the operator,
 *         with zero pass-through to the public.
 * @dev Draft for civic enforcement; integrates with levy, escrow, and audit systems.
 */
contract FullBurdenCoverageAct {
    address public steward;
    address public regulator;

    struct Company {
        string name;
        address operator;
        bool registered;
        uint256 totalExpensesCommitted;
        uint256 totalExpensesPaid;
        bool compliant;
    }

    mapping(address => Company) public companies;
    mapping(address => uint256) public dueExpenses;

    event CompanyRegistered(address indexed id, address indexed operator, string name);
    event ExpenseDeclared(address indexed operator, uint256 amount, string category);
    event ExpensePaid(address indexed operator, uint256 amount);
    event NonCompliance(address indexed operator, string reason, uint256 penalty);
    event ComplianceStatus(address indexed operator, bool compliant);

    modifier onlyAdmin() {
        require(msg.sender == steward || msg.sender == regulator, "Not admin");
        _;
    }

    constructor(address _regulator) {
        steward = msg.sender;
        regulator = _regulator;
    }

    // Register a covered company
    function registerCompany(address id, address op, string calldata name) external onlyAdmin {
        companies[id] = Company(name, op, true, 0, 0, true);
        emit CompanyRegistered(id, op, name);
    }

    // Declare an expense obligation (infra, operations, env, etc.)
    function declareExpense(address id, uint256 amount, string calldata category) external onlyAdmin {
        Company storage c = companies[id];
        require(c.registered, "Not registered");
        dueExpenses[c.operator] += amount;
        c.totalExpensesCommitted += amount;
        emit ExpenseDeclared(c.operator, amount, category);
    }

    // Company settles its declared expenses
    function payExpense() external payable {
        uint256 due = dueExpenses[msg.sender];
        require(due > 0, "No due expense");
        require(msg.value == due, "Incorrect amount");
        dueExpenses[msg.sender] = 0;
        companies[msg.sender].totalExpensesPaid += msg.value;
        emit ExpensePaid(msg.sender, msg.value);
        emit ComplianceStatus(msg.sender, true);
    }

    // Apply penalty for late or missed payment
    function applyPenalty(address id, uint256 amount, string calldata reason) external onlyAdmin {
        Company storage c = companies[id];
        require(c.registered, "Not registered");
        dueExpenses[c.operator] += amount;
        c.compliant = false;
        emit NonCompliance(c.operator, reason, amount);
        emit ComplianceStatus(c.operator, false);
    }

    // Mark compliant again after settlement
    function markCompliant(address id) external onlyAdmin {
        companies[id].compliant = true;
        emit ComplianceStatus(companies[id].operator, true);
    }
}
