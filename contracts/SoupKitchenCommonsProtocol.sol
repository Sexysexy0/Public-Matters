// contracts/SoupKitchenCommonsProtocol.sol
pragma solidity ^0.8.20;

/**
 * @title SoupKitchenCommonsProtocol
 * @notice Validator-grade contract to log communal feeding arcs in public schools.
 */
contract SoupKitchenCommonsProtocol {
    address public admin;

    struct Meal {
        string school;
        string menu;
        uint256 servings;
        uint256 timestamp;
    }

    Meal[] public meals;

    event MealServed(string school, string menu, uint256 servings, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function serveMeal(string calldata school, string calldata menu, uint256 servings) external onlyAdmin {
        meals.push(Meal(school, menu, servings, block.timestamp));
        emit MealServed(school, menu, servings, block.timestamp);
    }

    function totalMeals() external view returns (uint256) {
        return meals.length;
    }
}
