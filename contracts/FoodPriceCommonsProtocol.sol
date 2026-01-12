pragma solidity ^0.8.20;

contract FoodPriceCommonsProtocol {
    address public admin;

    struct FoodPrice {
        string item;         // e.g. rice, bread, meat
        uint256 value;       // communal price
        uint256 timestamp;
    }

    FoodPrice[] public foodPrices;

    event FoodPriceLogged(string item, uint256 value, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logFoodPrice(string calldata item, uint256 value) external onlyAdmin {
        foodPrices.push(FoodPrice(item, value, block.timestamp));
        emit FoodPriceLogged(item, value, block.timestamp);
    }

    function totalFoodPrices() external view returns (uint256) {
        return foodPrices.length;
    }
}
