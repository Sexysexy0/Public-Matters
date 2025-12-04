// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract DAOToNutritionEquityGrid {
    string public batchID = "1321.9.247";
    string public steward = "Vinvin";

    address public admin;

    struct Nutrition {
        string food;       // rice, fish, vegetables, dairy
        string status;     // equitable, pending, ghost
        uint256 timestamp;
    }

    Nutrition[] public foods;

    event NutritionLogged(string food, string status);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function logNutrition(string memory food, string memory status) public onlyAdmin {
        foods.push(Nutrition(food, status, block.timestamp));
        emit NutritionLogged(food, status);
    }

    function getNutrition(uint256 index) public view returns (string memory food, string memory status, uint256 timestamp) {
        Nutrition memory n = foods[index];
        return (n.food, n.status, n.timestamp);
    }
}
