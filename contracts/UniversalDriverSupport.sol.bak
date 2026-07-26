pragma solidity ^0.8.0;

contract UniversalDriverSupport {
    event SupportActivation(string driverType, uint256 subsidy);

    function qualifyDriver(string memory driverType, bool usesFuel, uint256 fuelPrice) public {
        if (usesFuel && fuelPrice > 70) {
            emit SupportActivation(driverType, fuelPrice / 2); // 50% subsidy
        }
    }
}
