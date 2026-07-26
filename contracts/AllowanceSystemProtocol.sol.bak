pragma solidity ^0.8.0;

contract AllowanceSystemProtocol {
    event AllowanceActivation(string driver, uint256 amount);

    function checkExpenses(string memory driver, uint256 expenses) public {
        if (expenses > 10000) {
            emit AllowanceActivation(driver, expenses / 3); // 1/3 allowance support
        }
    }
}
