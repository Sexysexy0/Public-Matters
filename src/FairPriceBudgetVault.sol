// SPDX-License-Identifier: MIT
pragma solidity 0.8.35;

/**
 * @title FairPriceBudgetVault
 * @notice Isang pinatibay na kontrata para sa budget, 50% reduction targets, 
 * automated safety buffer, at strict expense categorization caps.
 */
contract FairPriceBudgetVault {

    address public immutable steward;
    uint256 public baselineBudget;
    uint256 public targetReducedBudget; 
    
    // Safety Buffer percentage (Halimbawa: 15%)
    uint256 public constant BUFFER_PERCENTAGE = 15;
    uint256 public emergencyReserve;
    uint256 public totalAllocatedFunds;

    mapping(string => uint256) public categoryExpenses;
    mapping(string => uint256) public categoryCaps; // Strict caps per category
    bool public budgetLocked;

    event BudgetConfigured(uint256 baseline, uint256 reducedTarget);
    event FundsDeposited(uint256 totalAmount, uint256 reservedToSafetyBuffer);
    event ExpenseLogged(string category, uint256 amount, string note);
    event CategoryCapSet(string category, uint256 capLimit);
    event BudgetCapExceeded(string category, uint256 attempted, uint256 limit);
    event EmergencyBufferWithdrawn(uint256 amount, address indexed steward);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward access");
        _;
    }

    constructor(uint256 _baselineBudget) {
        steward = msg.sender;
        baselineBudget = _baselineBudget;
        targetReducedBudget = _baselineBudget / 2;
        budgetLocked = false;
    }

    /**
     * @notice Mag-deposito ng pondo kung saan awtomatikong napupunta ang 15% sa Emergency Safety Buffer
     */
    function depositFunds() external payable onlySteward {
        require(!budgetLocked, "Vault is locked");
        
        uint256 bufferAmount = (msg.value * BUFFER_PERCENTAGE) / 100;
        uint256 usableAmount = msg.value - bufferAmount;

        emergencyReserve += bufferAmount;
        totalAllocatedFunds += usableAmount;

        emit FundsDeposited(msg.value, bufferAmount);
    }

    /**
     * @notice Mag-set ng limit o cap para sa isang partikular na kategorya (hal. Pagkain, Kuryente)
     */
    function setCategoryCap(string memory category, uint256 capLimit) external onlySteward {
        categoryCaps[category] = capLimit;
        emit CategoryCapSet(category, capLimit);
    }

    /**
     * @notice Mag-log ng gastusin na may kasamang awtomatikong pag-check sa category cap
     */
    function logExpense(string memory category, uint256 amount, string memory note) external onlySteward {
        require(!budgetLocked, "Budget is locked due to emergency");
        
        uint256 currentCap = categoryCaps[category];
        if (currentCap > 0 && (categoryExpenses[category] + amount) > currentCap) {
            emit BudgetCapExceeded(category, categoryExpenses[category] + amount, currentCap);
            revert("Expense exceeds defined category cap limit");
        }

        categoryExpenses[category] += amount;
        emit ExpenseLogged(category, amount, note);
    }

    /**
     * @notice Pag-withdraw mula sa Emergency Safety Buffer kung sakaling kailanganin talaga
     */
    function withdrawEmergencyReserve(uint256 amount) external onlySteward {
        require(amount <= emergencyReserve, "Insufficient emergency reserve");
        emergencyReserve -= amount;
        
        (bool success, ) = payable(steward).call{value: amount}("");
        require(success, "Transfer failed");

        emit EmergencyBufferWithdrawn(amount, steward);
    }

    function updateBaseline(uint256 newBaseline) external onlySteward {
        baselineBudget = newBaseline;
        targetReducedBudget = newBaseline / 2;
        emit BudgetConfigured(newBaseline, targetReducedBudget);
    }

    function toggleLock(bool _lock) external onlySteward {
        budgetLocked = _lock;
    }
}
