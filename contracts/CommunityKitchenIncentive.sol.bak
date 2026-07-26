// CommunityKitchenIncentive.sol
// Logic: Incentivizing Affordable High-Protein Meals
pragma solidity ^0.8.0;

contract CommunityKitchenIncentive {
    mapping(address => uint256) public sovereignCredits;

    function logHealthyMeal(address _kitchen, uint256 _proteinGrams, uint256 _price) public {
        // Goal: Nutrisyon ng mayaman sa presyong masa.
        // If Price < 100 PHP and Protein > 25g, grant Sovereign Credits.
        if (_price <= 100 && _proteinGrams >= 25) {
            sovereignCredits[_kitchen] += 10;
        }
    }
}
