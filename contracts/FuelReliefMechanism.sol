pragma solidity ^0.8.0;

contract FuelReliefMechanism {
    event ReliefActivation(string driver, uint256 subsidy);

    function checkFuel(string memory driver, uint256 price) public {
        if (price > 70) {
            emit ReliefActivation(driver, price / 2); // 50% subsidy
        }
    }
}
