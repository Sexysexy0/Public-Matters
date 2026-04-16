pragma solidity ^0.8.0;

contract FuelSubsidyProtocol {
    event SubsidyActivation(string driver, uint256 discount);

    function checkFuelPrice(string memory driver, uint256 price) public {
        if (price > 70) {
            emit SubsidyActivation(driver, price / 2); // 50% discount
        }
    }
}
