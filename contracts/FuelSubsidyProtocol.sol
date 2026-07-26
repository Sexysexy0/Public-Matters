pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract FuelSubsidyProtocol is Ownable {

    constructor() Ownable(msg.sender) {}

    event SubsidyActivation(string driver, uint256 discount);

    function checkFuelPrice(string memory driver, uint256 price) public {
        if (price > 70) {
            emit SubsidyActivation(driver, price / 2); // 50% discount
        }
    }
}
