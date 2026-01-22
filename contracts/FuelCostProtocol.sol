pragma solidity ^0.8.20;

contract FuelCostProtocol {
    address public admin;

    struct Fuel {
        string vehicle;      // e.g. garbage truck
        uint256 price;       // e.g. current fuel cost per liter
        string impact;       // e.g. higher fees, operational strain
        uint256 timestamp;
    }

    Fuel[] public fuels;

    event FuelLogged(string vehicle, uint256 price, string impact, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logFuel(string calldata vehicle, uint256 price, string calldata impact) external onlyAdmin {
        fuels.push(Fuel(vehicle, price, impact, block.timestamp));
        emit FuelLogged(vehicle, price, impact, block.timestamp);
    }

    function totalFuels() external view returns (uint256) {
        return fuels.length;
    }
}
