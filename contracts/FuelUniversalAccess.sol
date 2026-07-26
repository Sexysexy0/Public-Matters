pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract FuelUniversalAccess is Ownable {

    constructor() Ownable(msg.sender) {}

    event Qualification(string driverType, uint256 subsidy);

    function qualify(string memory driverType, bool usesFuel, uint256 fuelPrice) public {
        if (usesFuel) {
            emit Qualification(driverType, fuelPrice / 2); // 50% subsidy
        }
    }
}
