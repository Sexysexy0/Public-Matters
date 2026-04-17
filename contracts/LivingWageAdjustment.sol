// LivingWageAdjustment.sol
pragma solidity ^0.8.0;

contract LivingWageAdjustment {
    uint256 public basicBasketPrice; // Presyo ng pangunahing pangangailangan

    function updateSalary(uint256 _newCPI) public {
        // Feed galing sa independent oracle, hindi sa gobyerno
        basicBasketPrice = _newCPI;
    }

    function calculatePay(uint256 _workHours) public view returns (uint256) {
        // Salary = Hours * (BasketPrice / StandardMonthHours)
        return (_workHours * basicBasketPrice) / 160;
    }
}
