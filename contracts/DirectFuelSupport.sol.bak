pragma solidity ^0.8.0;

contract DirectFuelSupport {
    event FuelSupportActivation(string driver, uint256 subsidy);

    function checkFuel(string memory driver, uint256 price) public {
        if (price > 70) {
            emit FuelSupportActivation(driver, price / 2); // 50% subsidy
        }
    }
}
