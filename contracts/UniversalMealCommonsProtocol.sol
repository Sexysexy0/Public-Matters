// contracts/UniversalMealCommonsProtocol.sol
pragma solidity ^0.8.20;

/**
 * @title UniversalMealCommonsProtocol
 * @notice Validator-grade contract to log communal feeding arcs across schools, barangay centers, hospitals, and shelters.
 */
contract UniversalMealCommonsProtocol {
    address public admin;

    struct Meal {
        string location;     // school, barangay center, hospital, shelter
        string menu;         // sabaw, kanin, gulay, ulam
        uint256 servings;    // number of meals served
        uint256 timestamp;
    }

    Meal[] public meals;

    event MealServed(string location, string menu, uint256 servings, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function serveMeal(string calldata location, string calldata menu, uint256 servings) external onlyAdmin {
        meals.push(Meal(location, menu, servings, block.timestamp));
        emit MealServed(location, menu, servings, block.timestamp);
    }

    function totalMeals() external view returns (uint256) {
        return meals.length;
    }
}
