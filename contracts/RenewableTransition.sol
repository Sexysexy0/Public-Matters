pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract RenewableTransition is Ownable {

    constructor() Ownable(msg.sender) {}

    event PriorityShift(uint256 oilPrice, string action);

    function checkOilPrice(uint256 _price) public {
        if (_price > 100) {
            emit PriorityShift(_price, "Allocate budget to solar & wind projects");
        }
    }
}
