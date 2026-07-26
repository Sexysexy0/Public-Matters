pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract FuelAllowanceShield is Ownable {

    constructor() Ownable(msg.sender) {}

    event AllowanceActivation(string driverType, uint256 allowance);

    function checkExpenses(string memory driverType, uint256 expenses) public {
        if (expenses > 10000) {
            emit AllowanceActivation(driverType, expenses / 3); // 1/3 allowance support
        }
    }
}
