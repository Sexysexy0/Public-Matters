// FoodEquityAudit.sol
// Logic: Ensuring Standardized Portions for All Classes
pragma solidity ^0.8.0;

contract FoodEquityAudit {
    function verifyPortion(uint256 _paidAmount, uint256 _actualGrams) public pure returns (bool) {
        // Goal: Stop the "Portion Wars". 
        // Ensure price per gram is consistent across all demographics.
        return (_actualGrams >= (_paidAmount / 10)); 
    }
}
